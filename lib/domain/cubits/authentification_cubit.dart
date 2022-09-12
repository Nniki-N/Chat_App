import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthentificationCubit extends HydratedCubit<UserModel> {
  final _firebaseAuth = FirebaseAuth.instance;

  bool _loading = false;
  String _errorText = '';
  late bool _isLogedIn;

  bool get isLogedIn => _isLogedIn;
  bool get loading => _loading;
  String get errorText => _errorText;

  AuthentificationCubit() : super(UserModel(uid: '', userName: '')) {
    _isLogedIn = state.isLoggedIn;
  }

  // clean error message when problem is solved
  void errorTextClean() {
    _errorText = '';
  }

  // create UserModel from firebase User
  UserModel? _userFromFirebaseUser({
    required User? user,
    required String userName,
  }) {
    return user != null
        ? UserModel(
            uid: user.uid,
            userName: userName,
          )
        : null;
  }

  // sign in
  Future<void> signInWithEmailAndPassword(String email, String password) async {
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

      // if sign in is successful update state with new data and show screen via _isLogedIn
      final newState = _userFromFirebaseUser(user: user, userName: '');
      if (newState != null) {
        _errorText = '';
        _isLogedIn = true;
        emit(newState.copyWith(isLoggedIn: _isLogedIn));
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

      // if sign out is successful update state with new data and show screen via _isLogedIn
      _errorText = '';
      _isLogedIn = false;
      emit(UserModel(uid: '', userName: '', isLoggedIn: _isLogedIn));
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
    String userName,
    String email,
    String password,
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

      // if registration is successful update state with new data and show another screen via _isLogedIn
      final newState = _userFromFirebaseUser(user: user, userName: '');
      if (newState != null) {
        _errorText = '';
        _isLogedIn = true;
        emit(newState.copyWith(isLoggedIn: _isLogedIn));
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

  // read data from storage
  @override
  UserModel? fromJson(Map<String, dynamic> json) {
    return state.copyWith(isLoggedIn: json['is_logged_in']);
  }

  // write data to storage
  @override
  Map<String, bool>? toJson(UserModel state) {
    return <String, bool>{
      'is_logged_in': state.isLoggedIn,
    };
  }
}
