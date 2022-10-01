import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:chat_app/domain/entity/app_authentification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthentificationCubit extends Cubit<AppAuthentificationModel> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _userDataProvider = UserDataProvider();

  bool _loading = false;
  String _errorText = '';
  bool _isLogedIn = FirebaseAuth.instance.currentUser != null;

  bool get isLogedIn => _isLogedIn;
  bool get loading => _loading;
  String get errorText => _errorText;

  AuthentificationCubit()
      : super(AppAuthentificationModel(
            userId: FirebaseAuth.instance.currentUser?.uid ?? '',
            isLoggedIn: false));

  // clean error message when problem is solved
  void errorTextClean() {
    _errorText = '';
  }

  // conver firebase user date into UserModel
  Future<UserModel?> _converFirebaseUserIntoUserModel(
      {required User? user, String userEmail = '', String userName = ''}) async {
    if (user == null) return null;

    // get UserModel from firebase firestore
    final result =
        await _userDataProvider.getUserFromFireBase(userId: user.uid,);
    if (result != null) return result;

    // return new UserModel if it absent in firebase firestore
    return UserModel(userId: user.uid, userEmail: userEmail, userName: userName);
  }

  // sign in
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      // show loading
      _loading = true;
      emit(state.copyWith());

      // sign in with email and password
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // get user from firebase firestore
      final userModel = await _converFirebaseUserIntoUserModel(user: user);
      if (userModel != null) {
        // upload new user state
        _userDataProvider.saveUserInFirebase(
            user: userModel.copyWith(isOnline: true, lastSeen: DateTime.now()));

        // save data in storage
        _errorText = '';
        _isLogedIn = true;
        emit(state.copyWith(userId: userModel.userId, isLoggedIn: _isLogedIn));
      }
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'user-not-found':
          _errorText = 'No user found for that email.';
          break;
        case 'invalid-email':
          _errorText = 'Email address is written wrong';
          break;
        case 'wrong-password':
          _errorText = 'Wrong password.';
          break;
        case 'user-disabled':
          _errorText = 'Your account has been disabled by an administrator';
          break;
        default:
          _errorText = 'Some error happened';
      }
      emit(state.copyWith());
    } finally {
      // hide loading
      _loading = false;
      emit(state.copyWith());
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      // show loading
      _loading = true;

      await _firebaseAuth.signOut();

      // get user from firebase
      final userModel =
          await _userDataProvider.getUserFromFireBase(userId: state.userId);
      if (userModel != null) {
        // upload new user state
        _userDataProvider.saveUserInFirebase(
            user:
                userModel.copyWith(isOnline: false, lastSeen: DateTime.now()));
      }

      // save data in storage
      _errorText = '';
      _loading = false;
      _isLogedIn = false;
      emit(state.copyWith(userId: '', isLoggedIn: _isLogedIn));
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'user-signed-out':
          _errorText = 'Invalid logout way.';
          break;
        default:
          _errorText = 'Some error happened';
      }
      emit(state.copyWith());
    } finally {
      // hide loading
      _loading = false;
      emit(state.copyWith());
    }
  }

  // register
  Future<void> registerWithEmailAndPassword(
    {required String userName,
    required String email,
    required String password,}
  ) async {
    try {
      // show loading
      _loading = true;
      emit(state.copyWith());

      // create new accaunt
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // get user from firebase firestore
      final userModel = await _converFirebaseUserIntoUserModel(
          user: user, userEmail: email, userName: userName);
      if (userModel != null) {
        // upload new user state
        _userDataProvider.saveUserInFirebase(user: userModel);

        // save data in storage
        _errorText = '';
        _isLogedIn = true;
        emit(state.copyWith(userId: userModel.userId, isLoggedIn: _isLogedIn));
      }
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'email-already-exists':
          _errorText = 'This email already exists.';
          break;
        case 'invalid-email':
          _errorText = 'Please write your email correctly';
          break;
        case 'weak-password':
          _errorText = 'Password shold be at least 6 characters.';
          break;
        default:
          _errorText = 'Some error happened';
      }
      emit(state.copyWith());
    } finally {
      // hide loading
      _loading = false;
      emit(state.copyWith());
    }
  }
}
