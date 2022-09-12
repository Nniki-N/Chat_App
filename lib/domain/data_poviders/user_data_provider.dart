import 'package:chat_app/domain/entity/user_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> saveUserInFirebase(UserModel user) async {
    try {
      _firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(user.userId)
          .set(user.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> getUserFromFireBase(String userId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(userId)
          .get();

      final json = snapshot.data();
      if (json != null) return UserModel.fromJson(json);
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<void> deleteUserFromFirebase(String userId) async {
    try {
      _firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(userId).delete();
    } catch (e) {
      print(e);
    }
  }
}
