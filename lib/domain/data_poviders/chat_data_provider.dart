import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  // update chat data in firebase
  Future<void> updateChatInFirebase({
    required String userId,
    required ChatModel chatModel,
  }) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatModel.chatId)
        .update(chatModel.toJson());
  }

  // update all chats avatars
  Future<void> updateAllChatsAvatarsInFirebase({
    required String userId,
    required String? userImageUrl,
  }) async {
    final snapshots = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .get();

    for (var doc in snapshots.docs) {
      final json = doc.data();
      final chatModel = ChatModel.fromJson(json);
      final contactUserId = chatModel.chatContactUserId;

      final contactUserChatModel =
          await getChatFromFirebase(userId: contactUserId, chatId: userId);

      if (contactUserChatModel == null) return;

      updateChatInFirebase(
          userId: contactUserId,
          chatModel: contactUserChatModel.copyWith(chatImageUrl: userImageUrl));
    }
  }

  // add chat to firebase
  Future<void> addChatToFirebase({
    required String userId,
    required ChatModel chatModel,
  }) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatModel.chatId)
        .set(chatModel.toJson());
  }

  // get chat from firebase if it exists
  Future<ChatModel?> getChatFromFirebase({
    required String userId,
    required String chatId,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .get();

    final json = snapshot.data();
    if (json != null) return ChatModel.fromJson(json);

    return null;
  }

  // check if chat exists
  Future<bool> chatExists({
    required String userId,
    required String chatId,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .get();

    if (snapshot.exists) return true;

    return false;
  }

  // get stream that notifies about any chat changes
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatsStreamFromFirestore({
    required String userId,
  }) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        _firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(userId)
            .collection(FirestoreConstants.pathChatCollection)
            .orderBy(FirestoreConstants.lastMessageTime, descending: true)
            .snapshots();

    return snapshots;
  }

  // delete all chats from firebase
  Future<void> deleteAllChatsFromFirebase({required String userId}) async {
    final batch = _firebaseFirestore.batch();

    final snapshots = await _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .get();

    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // delete chat from firebase
  Future<void> deleteChatFromFirebase({
    required String userId,
    required String chatId,
  }) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chatId)
        .delete();
  }
}
