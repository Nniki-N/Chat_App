import 'package:chat_app/domain/entity/message_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  // add new message in firebase
  Future<void> addMessageToFirebase({
    required String userId,
    required String chatId,
    required String messageId,
    required MessageModel messageModel,
  }) async {
    await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(messageId)
        .set(messageModel.toJson());
  }

  // update message data
  Future<void> updateMessageInFirebase({
    required String userId,
    required String chatId,
    required MessageModel textMessageModel,
  }) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(textMessageModel.messageId)
        .update(textMessageModel.toJson());
  }

  // get message from firebase
  Future<MessageModel?> getMessageFromFirebase({
    required String userId,
    required String chatId,
    required String messageId,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(messageId)
        .get();

    final json = snapshot.data();
    if (json != null) return MessageModel.fromJson(json);

    return null;
  }

  // get stream that notifies about any message changes
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

  // delete messages
  Future<void> deleteAllMessagesFromFirebase({
    required String userId,
    required String chatId,
  }) async {
    final batch = _firebaseFirestore.batch();

    final snapshots = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .get();

    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // delete message
  Future<void> deleteMessage({
    required String userId,
    required String chatId,
    required String messageId,
  }) async {
    await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(messageId)
        .delete();
  }
}
