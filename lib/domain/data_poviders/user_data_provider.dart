import 'package:chat_app/domain/entity/user_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  // save user data or create new document and save data in firebase
  Future<void> saveUserInFirebase({required UserModel user}) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(user.userId)
        .set(user.toJson());
  }

  // get user from firebase if user exists
  Future<UserModel?> getUserFromFireBase({required String userId}) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .get();

    final json = snapshot.data();
    if (json != null) return UserModel.fromJson(json);

    return null;
  }

  // get user from firebase by email if user exists
  Future<UserModel?> getUserByEmailFromFireBase({required String userEmail}) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where('user_email', isEqualTo: userEmail)
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
