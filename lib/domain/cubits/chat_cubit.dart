import 'package:chat_app/domain/data_poviders/chat_data_provider.dart';
import 'package:chat_app/domain/data_poviders/message_data_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/domain/entity/message_model.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:chat_app/ui/screens/chat_screen/message_item.dart';
import 'package:chat_app/ui/screens/chat_screen/my_message_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatCubit extends Cubit<ChatModel> {
  final _userDataProvider = UserDataProvider();
  final _chatDataProveder = ChatDataProvider();
  final _messageDataProveder = MessageDataProvider();

  final currentUser = UserModel(
    userId: FirebaseAuth.instance.currentUser?.uid ?? '',
    userEmail: FirebaseAuth.instance.currentUser?.email ?? '',
    userName: FirebaseAuth.instance.currentUser?.displayName ?? '',
  );

  late final _messagesStream =
      _messageDataProveder.getMessagesStreamFromFirebase(
          userId: currentUser.userId, chatId: state.chatId);

  final _messagesList = <MessageModel>[];
  List<MessageModel> get messagesList => _messagesList;

  Stream<QuerySnapshot<Map<String, dynamic>>> get messagesStream =>
      _messagesStream;

  ChatCubit({required ChatModel chatModel}) : super(chatModel) {
    _initialize();
  }

  // load state from firebase
  Future<void> _initialize() async {
    emit(state.copyWith(unreadMessagesCount: 0));

    // all messages are read
    await _chatDataProveder.saveChatInFirebase(
        userId: currentUser.userId, chat: state);

    // load messages
    _messagesStream.listen(
      (snapshot) {
        if (_messagesList.isEmpty) {
          final length = snapshot.docs.length;

          for (int i = 0; i < length; i++) {
            _messagesList.add(MessageModel.fromJson(snapshot.docs[i].data()));
          }
        } else {
          _messagesList.add(MessageModel.fromJson(snapshot.docs.last.data()));
        }
      },
    );

    emit(state.copyWith());
  }

  // send message
  Future<void> sendMessage({
    required String text,
    required ChatModel chatModel,
  }) async {
    final message = MessageModel(
      message: text,
      senderId: currentUser.userId,
      messageTime: DateTime.now(),
    );

    // send new messages
    await _messageDataProveder.addMessageInFirebase(
      userId: currentUser.userId,
      chatId: chatModel.chatId,
      message: message,
    );
    await _messageDataProveder.addMessageInFirebase(
      userId: chatModel.chatContactId,
      chatId: currentUser.userId,
      message: message,
    );

    // current user chat
    final currentUserChat = await _chatDataProveder.getChatFromFirebase(
      userId: currentUser.userId,
      chatId: state.chatId,
    );

    // contact user chat
    final contactUserChat = await _chatDataProveder.getChatFromFirebase(
      userId: state.chatContactId,
      chatId: currentUser.userId,
    );

    // update current user chat
    if (currentUserChat != null) {
      _chatDataProveder.saveChatInFirebase(
        userId: currentUser.userId,
        chat: currentUserChat.copyWith(
          lastMessage: text,
          lastMessageTime: DateTime.now(),
        ),
      );
    }

    // update conntact user chat
    if (contactUserChat != null) {
      _chatDataProveder.saveChatInFirebase(
        userId: state.chatContactId,
        chat: contactUserChat.copyWith(
          lastMessage: text,
          lastMessageTime: DateTime.now(),
          unreadMessagesCount: contactUserChat.unreadMessagesCount + 1,
        ),
      );
    }

    // save current user chat update
    // _chatDataProveder.saveChatInFirebase(
    //   userId: currentUser.userId,
    //   chat: state.copyWith(
    //     lastMessage: text,
    //     lastMessageTime: DateTime.now(),
    //   ),
    // );

    emit(state.copyWith());
  }

  // get widget view of message
  Widget getMessage({required MessageModel messageModel}) {
    if (messageModel.senderId == currentUser.userId) {
      return MyMessageItem(
        messageText: messageModel.message,
        messageDate: converDateInString(time: messageModel.messageTime),
      );
    } else {
      return MessageItem(
        messageText: messageModel.message,
        messageDate: converDateInString(time: messageModel.messageTime),
      );
    }
  }

  String converDateInString({required DateTime time}) =>
      DateFormat("hh:mm").format(time);
}
