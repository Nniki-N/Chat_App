import 'dart:async';
import 'package:chat_app/domain/data_poviders/auth_data_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

enum AuthState {
  initial,
  signedIn,
  signedOut,
  inProcess,
}

class AuthCubit extends Cubit<AuthState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _authDataProvider = AuthDataProvider();
  final _userDataProvider = UserDataProvider();

  // stream subscriptions
  StreamSubscription<String?>? _authStreamSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _chatsStreamSubscription;

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

  bool _showSingIn = true;
  bool get showSignIn => _showSingIn;

  UserModel? _currentUser;

  AuthCubit() : super(AuthState.initial) {
    _initialize();
  }

  Future<void> _initialize() async {
    _currentUser = await _userDataProvider.getUserFromFireBase(
        userId: _authDataProvider.getCurrentUserUID());

    // check when auth status changes and notifies
    _authStreamSubscription =
        _authDataProvider.onAuthStateChanged.listen((String? userId) {
      if (userId == null) {
        _currentUser = null;
        emit(AuthState.signedOut);
      } else {
        _userDataProvider
            .getUserFromFireBase(userId: _authDataProvider.getCurrentUserUID())
            .then((userModel) => _currentUser = userModel);
        emit(AuthState.signedIn);
      }
    });

    // check error text changes
    _errorTextStream = _errorTextStreamController.stream.asBroadcastStream();
    _errorTextStreamSubscription = _errorTextStream?.listen((value) {
      _errorText = value;
    });
  }

  // sign in
  Future<bool> signInWithEmailAndPassword({
    required String emailOrLogin,
    required String password,
  }) async {
    try {
      // show loading
      _loading = true;
      emit(AuthState.inProcess);

      if (emailOrLogin.contains('@gmail.com')) {
        // sign in with email and password
        final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: emailOrLogin,
          password: password,
        );
        final user = result.user;

        // check if sign in was successful
        final userModel = await _converFirebaseUserIntoUserModel(user: user);
        if (userModel != null) {
          // upload data of active status
          _userDataProvider.updateUserInFirebase(
              user:
                  userModel.copyWith(isOnline: true, lastSeen: DateTime.now()));

          _currentUser =
              userModel.copyWith(isOnline: true, lastSeen: DateTime.now());

          _setTextError('');
          emit(AuthState.signedIn);
          return true;
        } else {
          throw('No user found for that email.');
        }
      } else {
        // add @ if it isn't written
        if (emailOrLogin.indexOf('@') != 0) emailOrLogin = '@$emailOrLogin';

        UserModel? userModel = await _userDataProvider
            .getUserByLoginFromFireBase(userLogin: emailOrLogin);

        // stop if user absents
        if (userModel == null) {
          throw('No user found for that login.');
        }

        // sign in with email and password
        final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: userModel.userEmail,
          password: password,
        );
        final user = result.user;

        // check if sign in was successful
        userModel = await _converFirebaseUserIntoUserModel(user: user);
        if (userModel != null) {
          _userDataProvider.updateUserInFirebase(
              user:
                  userModel.copyWith(isOnline: true, lastSeen: DateTime.now()));

          _currentUser =
              userModel.copyWith(isOnline: true, lastSeen: DateTime.now());

          _setTextError('');
          emit(AuthState.signedIn);
          return true;
        } else {
          throw('Some error happened');
        }
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

      emit(AuthState.signedOut);
      return false;
    } catch (e) {
      _setTextError('$e');
      emit(AuthState.signedOut);
      return false;
    }finally {
      // hide loading
      _loading = false;
    }
  }

  // sign out
  Future<bool> signOut() async {
    try {
      // show loading
      _loading = true;
      emit(AuthState.inProcess);

      _currentUser = await _userDataProvider.getUserFromFireBase(
          userId: _authDataProvider.getCurrentUserUID());

      // stop if current user absents
      if (_currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // upload data of inactive status
      _userDataProvider.updateUserInFirebase(
          user: _currentUser!
              .copyWith(isOnline: false, lastSeen: DateTime.now()));

      await _firebaseAuth.signOut();

      _setTextError('');
      emit(AuthState.signedOut);
      return true;
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'user-signed-out':
          _setTextError('Invalid logout way.');
          break;
        default:
          _setTextError('Some error happened');
      }

      emit(AuthState.signedIn);
      return false;
    } catch (e) {
      _setTextError('$e');
      emit(AuthState.signedIn);
      return false;
    } finally {
      // hide loading
      _loading = false;
    }
  }

  // register
  Future<bool> registerWithEmailAndPassword({
    required String userName,
    required String email,
    required String userLogin,
    required String password,
  }) async {
    try {
      // show loading
      _loading = true;
      emit(AuthState.inProcess);

      // check if user login is uniq
      final isUserLoginUniq =
          await _userDataProvider.checkIfUserLoginIsUniq(userLogin: userLogin);
      if (!isUserLoginUniq) {
        throw ('This user login is already used');
      }

      // create new accaunt with email and password
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // get user from firebase firestore if user exists
      final userModel = await _converFirebaseUserIntoUserModel(
          user: user,
          userEmail: email,
          userName: userName,
          userLogin: userLogin);
      if (userModel != null) {
        // upload user's new data
        await _userDataProvider.addUserToFirebase(user: userModel);
        _currentUser = userModel;

        _setTextError('');
        changeShowSignIn(showSignIn: true);
        emit(AuthState.signedIn);
        return true;
      } else {
        throw('This user doesn\'t exist');
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

      emit(AuthState.signedOut);
      return false;
    } catch (e) {
      _setTextError('$e');
      emit(AuthState.signedOut);
      return false;
    } finally {
      // hide loading
      _loading = false;
    }
  }

  // conver firebase user date into UserModel
  Future<UserModel?> _converFirebaseUserIntoUserModel({
    required User? user,
    String userEmail = '',
    String userName = '',
    String userLogin = '',
  }) async {
    if (user == null) return null;

    // get UserModel from firebase firestore
    final result = await _userDataProvider.getUserFromFireBase(
      userId: user.uid,
    );
    if (result != null) return result;

    // return new UserModel if it absent in firebase firestore
    return UserModel(
        userId: user.uid,
        userEmail: userEmail,
        userName: userName,
        userLogin: userLogin);
  }

  // change which auth page display
  void changeShowSignIn({required showSignIn}) => _showSingIn = showSignIn;

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
    await _chatsStreamSubscription?.cancel();
    await _errorTextStreamSubscription?.cancel();
    return super.close();
  }
}
