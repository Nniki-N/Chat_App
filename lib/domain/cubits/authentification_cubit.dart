import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/domain/entity/user.dart' as custom_user;
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthentificationCubit extends Cubit<custom_user.User> {
  final _firebaseAuth = FirebaseAuth.instance;
  bool _loading = false;
  String _errorText = '';
  late bool _isLogedIn;

  bool get isLogedIn => _isLogedIn;
  bool get loading => _loading;
  String get errorText => _errorText;

  AuthentificationCubit()
      : super(custom_user.User(
          uid: '',
          userName: '',
          email: '',
          password: '',
        )) {
    _isLogedIn = false;
  }

  void errorTextClean() {
    _errorText = '';
  }

  custom_user.User? _userFromFirebaseUser({
    required User? user,
    required String userName,
    required String email,
    required String password,
  }) {
    return user != null
        ? custom_user.User(
            uid: user.uid,
            userName: userName,
            email: email,
            password: password,
          )
        : null;
  }

  // sign in
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _loading = true;
      emit(state.copyWith());

      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      final newState = _userFromFirebaseUser(
          user: user, userName: '', email: email, password: password);
      if (newState != null) {
        _errorText = '';
        _isLogedIn = true;
        emit(newState);
      }
    } catch (e) {
      _errorText = e.toString();
      emit(state.copyWith());
    } finally {
      _loading = false;
      emit(state.copyWith());
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      _loading = true;

      await _firebaseAuth.signOut();
      emit(custom_user.User(uid: '', userName: '', email: '', password: ' '));

      _errorText = '';
      _isLogedIn = false;
    } catch (e) {
      _errorText = e.toString();
      emit(state.copyWith());
    } finally {
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
      _loading = true;
      emit(state.copyWith());

      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      final newState = _userFromFirebaseUser(
          user: user, userName: '', email: email, password: password);
      if (newState != null) {
        _errorText = '';
        _isLogedIn = true;
        emit(newState);
      }
    } catch (e) {
      _errorText = e.toString();
      emit(state.copyWith());
    } finally {
      _loading = false;
      emit(state.copyWith());
    }
  }
}
