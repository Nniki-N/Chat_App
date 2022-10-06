import 'package:chat_app/domain/entity/message_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  // add new message in firebase
  Future<void> addMessageToFirebase({
    required String userId,
    required String chatId,
    required MessageModel messageModel,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .add(messageModel.toJson());

    await snapshot.update(messageModel.copyWith(messageId: snapshot.id).toJson());
  }

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

  // update message data
  Future<void> updateMessageInFirebase({
    required String userId,
    required String chatId,
    required MessageModel messageModel,
  }) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(messageModel.messageId)
        .update(messageModel.toJson());
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
