import 'package:chat_app/domain/entity/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDataProvider {
  final _firebaseAuth = FirebaseAuth.instance;

  // get stream that notifies about changes to the user's sign-in state
  Stream<String?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().asyncMap((user) => user?.uid);
  }

  // create current user from uid, email and name
  UserModel? getCurrentUser() {
    if (_firebaseAuth.currentUser == null) return null;

    return UserModel(
      userId: _firebaseAuth.currentUser!.uid,
      userEmail: _firebaseAuth.currentUser?.email ?? '',
      userName: _firebaseAuth.currentUser?.displayName ?? '',
    );
  }

  // get current user UID
  String getCurrentUserUID() {
    return getCurrentUser()?.userId ?? '';
  }
}
