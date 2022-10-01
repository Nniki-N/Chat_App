import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/ui/utils/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDataProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> saveChatInFirebase({
    required String userId,
    required ChatModel chat,
  }) async {
    _firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .collection(FirestoreConstants.pathChatCollection)
        .doc(chat.chatId)
        .set(chat.toJson());
  }

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

    if (!snapshot.exists || snapshot == null) return false;

    return true;
  }

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
