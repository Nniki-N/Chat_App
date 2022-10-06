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
        .set(chatModel.toJson());
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
