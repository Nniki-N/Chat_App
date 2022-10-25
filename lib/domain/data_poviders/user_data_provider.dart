import 'package:chat_app/domain/entity/user_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  // save user data or create new document and save data in firebase
  Future<void> updateUserInFirebase({required UserModel user}) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(user.userId)
        .update(user.toJson());
  }

  // update user login in firebase
  Future<void> updateUserLoginInFirebase({
    required String userId,
    required String userLogin,
  }) async {
    final result = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.userLogin, isEqualTo: userLogin)
        .get();

    // check if login is uniq
    for (var queryDocumentSnapshot in result.docs) {
      final json = queryDocumentSnapshot.data();
      if (json[FirestoreConstants.userId] == userId) {
        continue;
      } else {
        throw Exception('This login is already used');
      }
    }

    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .update({FirestoreConstants.userLogin: userLogin});
  }

  Future<bool> checkIfUserLoginIsUniq({required String userLogin}) async {
    final result = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.userLogin, isEqualTo: userLogin)
        .get();

    // check if login is uniq
    if (result.docs.isNotEmpty) return false;

    return true;
  }

  // update user name in firebase
  Future<void> updateUserNameInFirebase({
    required String userId,
    required String userName,
  }) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .update({FirestoreConstants.userName: userName});
  }

  Future<void> addUserToFirebase({required UserModel user}) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(user.userId)
        .set(user.toJson());
  }

  // get user from firebase if user exists
  Future<UserModel?> getUserFromFireBase({required String? userId}) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .get();

    final json = snapshot.data();
    if (json != null) return UserModel.fromJson(json);

    return null;
  }

  // get stream that notifies about user changes
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStreamFromFiebase({
    required String userId,
  }) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        _firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(userId)
            .snapshots();

    return snapshots;
  }

  // get user from firebase by email if user exists
  Future<UserModel?> getUserByEmailFromFireBase(
      {required String userEmail}) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where('user_email', isEqualTo: userEmail)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final json = snapshot.docs.first.data();
    return UserModel.fromJson(json);
  }

  // get user from firebase by login if user exists
  Future<UserModel?> getUserByLoginFromFireBase(
      {required String userLogin}) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where('user_login', isEqualTo: userLogin)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final json = snapshot.docs.first.data();
    return UserModel.fromJson(json);
  }

  // delete user from firebase
  Future<void> deleteUserFromFirebase({required String userId}) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .delete();
  }
}
