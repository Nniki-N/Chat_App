import 'package:chat_app/domain/entity/message_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addMessageInFirebase({
    required String userId,
    required String chatId,
    required MessageModel message,
  }) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .add(message.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStreamFromFirebase({
    required String userId,
    required String chatId,
  }) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        _firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(userId)
            .collection(FirestoreConstants.pathChatCollection)
            .doc(chatId)
            .collection(FirestoreConstants.pathMessageCollection)
            .orderBy(FirestoreConstants.messageTime, descending: false)
            .snapshots();

    return snapshots;
  }
}
