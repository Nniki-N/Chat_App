// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:chat_app/domain/data_poviders/auth_data_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:chat_app/domain/data_poviders/chat_data_provider.dart';
import 'package:chat_app/domain/data_poviders/message_data_provider.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/domain/entity/message_model.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:chat_app/ui/screens/chat_screen/chat_date_separator.dart';
import 'package:chat_app/ui/screens/chat_screen/message_item.dart';
import 'package:chat_app/ui/screens/chat_screen/my_message_item.dart';

class ChatState {
  final UserModel? currentUser;
  final ChatModel currentChat;

  ChatState({
    required this.currentUser,
    required this.currentChat,
  });

  ChatState copyWith({
    UserModel? currentUser,
    ChatModel? currentChat,
  }) {
    return ChatState(
      currentUser: currentUser ?? this.currentUser,
      currentChat: currentChat ?? this.currentChat,
    );
  }
}

class ChatCubit extends Cubit<ChatState> {
  final _authDataProvider = AuthDataProvider();
  final _userDataProvider = UserDataProvider();
  final _chatDataProveder = ChatDataProvider();
  final _messageDataProveder = MessageDataProvider();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messagesStreamSubscription;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _messagesStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get messagesStream =>
      _messagesStream;

  final _messagesList = <MessageModel>[];
  Iterable<MessageModel> get messagesList sync* {
    for (var message in _messagesList) {
      yield message;
    }
  }

  DateTime lastMessageInListTime = DateTime.now();

  ChatCubit({required ChatModel chatModel})
      : super(ChatState(
          currentUser: null,
          currentChat: chatModel,
        )) {
    _initialize();
  }

  // load state from firebase
  Future<void> _initialize() async {
    final currentUser = await _userDataProvider.getUserFromFireBase(
        userId: _authDataProvider.getCurrentUserUID());

    // stop initialization if current user absents
    if (currentUser == null) return;

    // load current user state and show loading
    emit(state.copyWith(
      currentUser: currentUser,
      currentChat: state.currentChat.copyWith(unreadMessagesCount: 0),
    ));

    // all messages are read
    await _chatDataProveder.saveChatInFirebase(
        userId: currentUser.userId, chat: state.currentChat);

    // load messages
    _messagesStream = _messageDataProveder.getMessagesStreamFromFirebase(
      userId: currentUser.userId,
      chatId: state.currentChat.chatId,
    );
    _messagesStreamSubscription = _messagesStream?.listen(
      (snapshot) {
        if (_messagesList.isEmpty) {
          final length = snapshot.docs.length;

          for (int i = 0; i < length; i++) {
            final messageModel = MessageModel.fromJson(snapshot.docs[i].data());
            _messagesList.insert(0, messageModel);
          }
        } else {
          final messageModel = MessageModel.fromJson(snapshot.docs.last.data());
          _messagesList.insert(0, messageModel);
        }
      },
    );

    emit(state.copyWith());
  }

  // send message
  Future<void> sendMessage({required String text}) async {
    final currentUser = state.currentUser;

    // stop if current user absents
    if (currentUser == null) return;

    final message = MessageModel(
      message: text,
      senderId: currentUser.userId,
      messageTime: DateTime.now(),
    );

    // send new messages
    await _messageDataProveder.addMessageInFirebase(
      userId: currentUser.userId,
      chatId: state.currentChat.chatId,
      message: message,
    );
    await _messageDataProveder.addMessageInFirebase(
      userId: state.currentChat.chatContactId,
      chatId: currentUser.userId,
      message: message,
    );

    // current user chat
    final currentUserChat = await _chatDataProveder.getChatFromFirebase(
      userId: currentUser.userId,
      chatId: state.currentChat.chatId,
    );

    // contact user chat
    final contactUserChat = await _chatDataProveder.getChatFromFirebase(
      userId: state.currentChat.chatContactId,
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
        userId: state.currentChat.chatContactId,
        chat: contactUserChat.copyWith(
          lastMessage: text,
          lastMessageTime: DateTime.now(),
          unreadMessagesCount: contactUserChat.unreadMessagesCount + 1,
        ),
      );
    }

    emit(state.copyWith());
  }

  // get widget view of message
  Widget? getMessageView({required int index}) {
    final currentUser = state.currentUser;

    // stop if current user absents
    if (currentUser == null) return null;

    MessageModel messageModel = _messagesList[index];

    // return message with date of creating chat
    if (index == _messagesList.length - 1) {
      if (messageModel.senderId == currentUser.userId) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatDateSeparator(date: _getMessageDate(date: messageModel.messageTime)),
            MyMessageItem(
              messageText: messageModel.message,
              messageDate: _getMessageTime(time: messageModel.messageTime),
            ),
          ],
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatDateSeparator(date: _getMessageDate(date: messageModel.messageTime)),
            MessageItem(
              messageText: messageModel.message,
              messageDate: _getMessageTime(time: messageModel.messageTime),
            ),
          ],
        );
      }
    }

    // return message
    if (messageModel.senderId == currentUser.userId) {
      return MyMessageItem(
        messageText: messageModel.message,
        messageDate: _getMessageTime(time: messageModel.messageTime),
      );
    } else {
      return MessageItem(
        messageText: messageModel.message,
        messageDate: _getMessageTime(time: messageModel.messageTime),
      );
    }
  }

  // get separator with date
  Widget? getMessageDateView({required int index}) {
    MessageModel messageModel = _messagesList[index];

    if (index < _messagesList.length - 1) {
      if (messageModel.messageTime.year != DateTime.now().year) {
        return ChatDateSeparator(
            date: DateFormat("d MMM yyyy").format(messageModel.messageTime));
      } else if (messageModel.messageTime.day !=
          _messagesList[index + 1].messageTime.day) {
        return ChatDateSeparator(
            date: DateFormat("d MMM").format(messageModel.messageTime));
      }
    }

    return null;
  }

  // get message date in format day and month
  String _getMessageDate({required DateTime date}) {
    if (date.year != DateTime.now().year) {
      return DateFormat("d MMM yyyy").format(date);
    } else {
      return DateFormat("d MMM").format(date);
    }
  }

  // get message time in gormat hours and minutes
  String _getMessageTime({required DateTime time}) =>
      DateFormat("hh:mm").format(time);

  @override
  Future<void> close() async {
    await _messagesStreamSubscription?.cancel();
    return super.close();
  }
}
