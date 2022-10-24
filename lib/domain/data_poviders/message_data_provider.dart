import 'package:chat_app/domain/entity/text_message_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  // add new message in firebase
  Future<void> addTextMessageToFirebase({
    required String userId,
    required String chatId,
    required TextMessageModel textMessageModel,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .collection(FirestoreConstants.pathMessageCollection)
        .add(textMessageModel.toJson());

    await snapshot
        .update(textMessageModel.copyWith(messageId: snapshot.id).toJson());
  }

  // update message data
  Future<void> updateTextMessageInFirebase({
    required String userId,
    required String chatId,
    required TextMessageModel textMessageModel,
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
  Future<TextMessageModel?> getTextMessageFromFirebase({
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
    if (json != null) return TextMessageModel.fromJson(json);

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
