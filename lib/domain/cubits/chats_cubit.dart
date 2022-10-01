import 'dart:async';

import 'package:chat_app/domain/data_poviders/chat_data_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:chat_app/domain/entity/chat_configuration.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';

class ChatsCubit extends Cubit<UserModel> {
  final _userDataProvider = UserDataProvider();
  final _chatDataProveder = ChatDataProvider();

  late final _chatsStream = _chatDataProveder.getChatsStreamFromFirestore(
      userId: FirebaseAuth.instance.currentUser?.uid ?? state.userId);

  final _fullChatsList = <ChatModel>[];
  bool loading = false;
  String _searchText = '';
  String _errorText = '';

  String get errorText => _errorText;

  Stream<QuerySnapshot<Map<String, dynamic>>> get chatsStream => _chatsStream;

  ChatsCubit()
      : super(UserModel(
          userId: FirebaseAuth.instance.currentUser?.uid ?? '',
          userEmail: FirebaseAuth.instance.currentUser?.email ?? '',
          userName: FirebaseAuth.instance.currentUser?.displayName ?? '',
        )) {
    _initialize();
  }

  // load state from firebase
  Future<void> _initialize() async {
    // show loading
    loading = true;
    emit(state.copyWith());

    _chatsStream.listen(
      (snapshot) {
        _fullChatsList.clear();
        final length = snapshot.docs.length;
        for (int i = 0; i < length; i++) {
          _fullChatsList.add(ChatModel.fromJson(snapshot.docs[i].data()));
        }
      },
    );

    // load state from firebase
    final userModel =
        await _userDataProvider.getUserFromFireBase(userId: state.userId);
    if (userModel != null) {
      // update state and hide loading
      loading = false;
      emit(userModel);
    }
  }

  // create new chat
  Future<void> createNewChat({required String userEmail}) async {
    loading = true;
    emit(state.copyWith());

    if (userEmail == state.userEmail) {
      _errorText = 'This is your E-mail';
      loading = false;
      emit(state.copyWith());
      return;
    }

    UserModel? user = await _userDataProvider.getUserByEmailFromFireBase(
        userEmail: userEmail);

    if (user == null) {
      _errorText = 'User with this E-mail doesn\'t exist';
      loading = false;
      emit(state.copyWith());
      return;
    }

    final chatExist = await _chatDataProveder.chatExists(
        userId: state.userId, chatId: user.userId);

    if (chatExist) {
      _errorText = 'This chat already exists';
      loading = false;
      emit(state.copyWith());
      return;
    }

    // chat model for contact user
    ChatModel contactUserChat = ChatModel(
      chatId: state.userId,
      chatName: state.userName,
      chatContactId: state.userId,
      lastMessage: '',
      unreadMessagesCount: 0,
      lastMessageTime: DateTime.now(),
    );

    // chat model for current user
    ChatModel currentUserChat = ChatModel(
      chatId: user.userId,
      chatName: user.userName,
      chatContactId: user.userId,
      lastMessage: '',
      unreadMessagesCount: 0,
      lastMessageTime: DateTime.now(),
    );

    // add chat to current user and contact user
    _chatDataProveder.saveChatInFirebase(
        userId: state.userId, chat: currentUserChat);
    _chatDataProveder.saveChatInFirebase(
        userId: user.userId, chat: contactUserChat);

    _errorText = '';

    loading = false;
    emit(state.copyWith());
  }

  // show chat
  Future<void> showChat({
    required BuildContext context,
    required String userId,
    required ChatModel chatModel,
  }) async {
    final userModel =
        await _userDataProvider.getUserFromFireBase(userId: userId);

    if (userModel == null) return;

    final chatConfiguration =
        ChatConfiguration(user: userModel, chat: chatModel);

    Navigator.of(context).pushNamed(MainNavigationRouteNames.chatScreen,
        arguments: chatConfiguration);
  }

  // convert date of message to defferent formats depend on date
  String converDateInString({required ChatModel chatModel}) {
    if (chatModel.lastMessageTime.year != DateTime.now().year) {
      return DateFormat("dd.MM.yyyy").format(chatModel.lastMessageTime);
    } else if (chatModel.lastMessageTime.day != DateTime.now().day) {
      return DateFormat("hh:mm").format(chatModel.lastMessageTime);
    }

    // default format
    return DateFormat("MMM d").format(chatModel.lastMessageTime);
  }

  // set search text from field
  void setSearchText({required String text}) {
    _searchText = text;
    emit(state.copyWith());
  }

  // load chats list
  List<ChatModel> getChatsList() {
    final List<ChatModel> chatsList = [];

    // load only those chats that contains searchText in name
    _fullChatsList.forEach((element) {
      if (element.chatName.contains(_searchText)) {
        chatsList.add(element);
      }
    });

    return chatsList;
  }
}
