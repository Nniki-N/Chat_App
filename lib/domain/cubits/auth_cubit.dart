import 'dart:async';
import 'package:chat_app/domain/data_poviders/auth_data_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

enum AuthState {
  initial,
  signedIn,
  signedOut,
}

class AuthCubit extends Cubit<AuthState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _authDataProvider = AuthDataProvider();
  final _userDataProvider = UserDataProvider();

  // ckeck auth state changes
  StreamSubscription<String?>? _authStreamSubscription;

  // check error text changes
  final _errorTextStreamController = StreamController<String>();
  StreamSubscription<String>? _errorTextStreamSubscription;
  Stream<String>? _errorTextStream;

  Stream<String>? get errorTextStream => _errorTextStream;

  // is used to display status to user
  bool _loading = false;
  String _errorText = '';
  bool get loading => _loading;
  String get errorText => _errorText;

  AuthCubit() : super(AuthState.initial) {
    _initialize();
  }

  Future<void> _initialize() async {
    // check when auth status changes and notifies
    _authStreamSubscription = _authDataProvider.onAuthStateChanged.listen(
        (String? userId) => userId == null
            ? emit(AuthState.signedOut)
            : emit(AuthState.signedIn));

    // check error text changes
    _errorTextStream = _errorTextStreamController.stream.asBroadcastStream();
    _errorTextStreamSubscription = _errorTextStream?.listen((value) {
      _errorText = value;
    });
  }

  // sign in
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      // show loading
      _loading = true;
      emit(AuthState.signedOut);

      // sign in with email and password
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // get user from firebase firestore
      final userModel = await _converFirebaseUserIntoUserModel(user: user);
      if (userModel != null) {
        // upload data of active status
        _userDataProvider.updateUserInFirebase(
            user: userModel.copyWith(isOnline: true, lastSeen: DateTime.now()));

        // notifies about changes
        _setTextError('');
        _loading = false;
        emit(AuthState.signedIn);
      }
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'user-not-found':
          _setTextError('No user found for that email.');
          break;
        case 'invalid-email':
          _setTextError('Email address is written wrong');
          break;
        case 'wrong-password':
          _setTextError('Wrong password.');
          break;
        case 'user-disabled':
          _setTextError('Your account has been disabled by an administrator');
          break;
        default:
          _setTextError('Some error happened');
      }

      _loading = false;
      emit(AuthState.signedOut);
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      // show loading
      _loading = true;

      // get user from firebase
      final userModel = await _userDataProvider.getUserFromFireBase(
          userId: _authDataProvider.getCurrentUserUID());

      await _firebaseAuth.signOut();

      // if sign out is successful
      if (userModel != null) {
        // upload data of inactive status
        _userDataProvider.updateUserInFirebase(
            user:
                userModel.copyWith(isOnline: false, lastSeen: DateTime.now()));
      }

      // notifies about changes
      _setTextError('');
      _loading = false;
      emit(AuthState.signedOut);
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'user-signed-out':
          _setTextError('Invalid logout way.');
          break;
        default:
          _setTextError('Some error happened');
      }

      _loading = false;
      emit(AuthState.signedIn);
    }
  }

  // register
  Future<void> registerWithEmailAndPassword({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      // show loading
      _loading = true;
      emit(AuthState.signedOut);

      // create new accaunt with email and password
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // get user from firebase firestore
      final userModel = await _converFirebaseUserIntoUserModel(
          user: user, userEmail: email, userName: userName);
      if (userModel != null) {
        // upload user's new data
        _userDataProvider.addUserToFirebase(user: userModel);

        // notifies about changes
        _setTextError('');
        _loading = false;
        emit(AuthState.signedIn);
      }
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'email-already-exists':
          _setTextError('This email already exists.');
          break;
        case 'invalid-email':
          _setTextError('Please write your email correctly');
          break;
        case 'weak-password':
          _setTextError('Password shold be at least 6 characters.');
          break;
        default:
          _setTextError('Some error happened');
      }

      _loading = false;
      emit(AuthState.signedOut);
    }
  }

  // conver firebase user date into UserModel
  Future<UserModel?> _converFirebaseUserIntoUserModel({
    required User? user,
    String userEmail = '',
    String userName = '',
  }) async {
    if (user == null) return null;

    // get UserModel from firebase firestore
    final result = await _userDataProvider.getUserFromFireBase(
      userId: user.uid,
    );
    if (result != null) return result;

    // return new UserModel if it absent in firebase firestore
    return UserModel(
        userId: user.uid, userEmail: userEmail, userName: userName);
  }

  // clean error text
  void errorTextClean() {
    _setTextError('');
  }

  // set error text
  void _setTextError(String errorText) {
    _errorTextStreamController.add(errorText);
  }

  @override
  Future<void> close() async {
    await _authStreamSubscription?.cancel();
    await _errorTextStreamSubscription?.cancel();
    return super.close();
  }
}
