import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/domain/data_poviders/auth_data_provider.dart';
import 'package:chat_app/domain/data_poviders/chat_data_provider.dart';
import 'package:chat_app/domain/data_poviders/message_data_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:chat_app/domain/entity/chat_configuration.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/domain/entity/user_model.dart';

class ChatsState {
  final bool loading;
  final UserModel? currentUser;

  ChatsState({
    required this.loading,
    required this.currentUser,
  });

  ChatsState copyWith({
    bool? loading,
    UserModel? currentUser,
  }) {
    return ChatsState(
      loading: loading ?? this.loading,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class ChatsCubit extends Cubit<ChatsState> {
  final _authDataProvider = AuthDataProvider();
  final _userDataProvider = UserDataProvider();
  final _chatDataProveder = ChatDataProvider();
  final _messageDataProveder = MessageDataProvider();

  // check chats changes
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _chatsStreamSubscriprion;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _chatsStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get chatsStream => _chatsStream;

  // check error text changes
  final _errorTextStreamController = StreamController<String>();
  StreamSubscription<String>? _errorTextStreamSubscription;
  Stream<String>? _errorTextStream;

  Stream<String>? get errorTextStream => _errorTextStream;

  final _fullChatsList = <ChatModel>[];

  // is used to display status for user
  String _searchText = '';
  String _errorText = '';
  String get errorText => _errorText;

  ChatsCubit() : super(ChatsState(loading: false, currentUser: null)) {
    _initialize();
  }

  Future<void> _initialize() async {
    final currentUser = await _userDataProvider.getUserFromFireBase(
        userId: _authDataProvider.getCurrentUserUID());

    // stop initialization if current user absents
    if (currentUser == null) {
      _setTextError('You aren\'t signed in');
      return;
    }

    // load current user state and show loading
    emit(state.copyWith(loading: true, currentUser: currentUser));

    // check changes in chats
    _chatsStream = _chatDataProveder
        .getChatsStreamFromFirestore(userId: currentUser.userId)
        .asBroadcastStream();
    _chatsStreamSubscriprion = _chatsStream?.listen(
      (snapshot) {
        _fullChatsList.clear();

        for (var chat in snapshot.docs) {
          _fullChatsList.add(ChatModel.fromJson(chat.data()));
        }
      },
    );

    // check when error text changes
    _errorTextStream = _errorTextStreamController.stream.asBroadcastStream();
    _errorTextStreamSubscription = _errorTextStream?.listen((value) {
      _errorText = value;
    });

    // hide loading
    emit(state.copyWith(loading: false));
  }

  // create new chat
  Future<bool> createNewChat({required String userEmail}) async {
    final currentUser = state.currentUser;

    // stop if current user absents
    if (currentUser == null) {
      _setTextError('You aren\'t signed in');
      return false;
    }

    // show loading
    emit(state.copyWith(loading: true));

    // stop if is's current user
    if (userEmail == currentUser.userEmail) {
      _setTextError('This\'s your E-mail');

      // hide loading
      emit(state.copyWith(loading: false));
      return false;
    }

    // user we want to contact
    UserModel? contactUser = await _userDataProvider.getUserByEmailFromFireBase(
        userEmail: userEmail);

    // stop if user doesn't exist
    if (contactUser == null) {
      _setTextError('User with this E-mail doesn\'t exist');

      // hide loading
      emit(state.copyWith(loading: false));
      return false;
    }

    // check if chat exists
    final chatExist = await _chatDataProveder.chatExists(
        userId: currentUser.userId, chatId: contactUser.userId);

    if (chatExist) {
      _setTextError('This chat already exists');

      // hide loading
      emit(state.copyWith(loading: false));
      return false;
    }

    // create chat model for contact user
    ChatModel contactUserChat = ChatModel(
      chatId: currentUser.userId,
      chatName: currentUser.userName,
      chatContactId: currentUser.userId,
      lastMessage: '',
      unreadMessagesCount: 0,
      chatCreatedTime: DateTime.now(),
      lastMessageTime: DateTime.now(),
    );

    // create chat model for current user
    ChatModel currentUserChat = ChatModel(
      chatId: contactUser.userId,
      chatName: contactUser.userName,
      chatContactId: contactUser.userId,
      lastMessage: '',
      unreadMessagesCount: 0,
      chatCreatedTime: DateTime.now(),
      lastMessageTime: DateTime.now(),
    );

    // add chat to current user and contact user
    await _chatDataProveder.saveChatInFirebase(
        userId: currentUser.userId, chat: currentUserChat);
    await _chatDataProveder.saveChatInFirebase(
        userId: contactUser.userId, chat: contactUserChat);

    _setTextError('');

    // hide loading
    emit(state.copyWith(loading: false));
    return true;
  }

  // show chat
  Future<ChatConfiguration?> showChat({
    required String contactUserId,
    required ChatModel chatModel,
  }) async {
    final contactUser =
        await _userDataProvider.getUserFromFireBase(userId: contactUserId);

    // stop if contact user doesn't exist
    if (contactUser == null) return null;

    final chatConfiguration =
        ChatConfiguration(contactUser: contactUser, chat: chatModel);

    return chatConfiguration;
  }

  Future<void> deleteChat({required ChatModel chatModel}) async {
    final currentUser = state.currentUser;

    // stop if current user absents
    if (currentUser == null) {
      _setTextError('You aren\'t signed in');
      return;
    }

    // delete messages
    _messageDataProveder.deleteAllMessagesFromFirebase(
        userId: currentUser.userId, chatId: chatModel.chatId);
    _messageDataProveder.deleteAllMessagesFromFirebase(
        userId: chatModel.chatContactId, chatId: currentUser.userId);

    // delete chats
    await _chatDataProveder.deleteChatFromFirebase(
        userId: currentUser.userId, chatId: chatModel.chatId);
    await _chatDataProveder.deleteChatFromFirebase(
        userId: chatModel.chatContactId, chatId: currentUser.userId);
  }

  // load chats list
  Iterable<ChatModel> getChatsList() sync* {
    for (ChatModel chat in _fullChatsList) {
      if (chat.chatName.contains(_searchText)) {
        yield chat;
      }
    }
  }

  // set search text from field
  void setSearchText({required String searchText}) {
    _searchText = searchText;
    emit(state.copyWith());
  }

  // convert date of message to defferent formats depend on date
  String converDateInString({required DateTime dateTime}) {
    if (dateTime.year != DateTime.now().year) {
      return DateFormat("dd.MM.yyyy").format(dateTime);
    } else if (dateTime.day != DateTime.now().day) {
      return DateFormat("MMM d").format(dateTime);
    }

    // default format
    return DateFormat("hh:mm").format(dateTime);
  }

  // clean error text
  void errorTextClean() {
    _setTextError('');
  }

  // set error text
  void _setTextError(String errorText) {
    _errorTextStreamController.add(errorText);
  }

  @override
  Future<void> close() async {
    await _chatsStreamSubscriprion?.cancel();
    await _errorTextStreamSubscription?.cancel();
    return super.close();
  }
}
