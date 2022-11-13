import 'dart:async';
import 'package:camera/camera.dart';
import 'package:chat_app/domain/data_poviders/language_provider.dart';
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
  final UserModel? currentUser;

  ChatsState({
    required this.currentUser,
  });

  ChatsState copyWith({
    UserModel? currentUser,
  }) {
    return ChatsState(
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class ChatsCubit extends Cubit<ChatsState> {
  final _authDataProvider = AuthDataProvider();
  final _userDataProvider = UserDataProvider();
  final _chatDataProveder = ChatDataProvider();
  final _messageDataProveder = MessageDataProvider();
  final _languageProvider = LanguageProvider();

  // check chats changes
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _chatsStreamSubscriprion;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _chatsStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get chatsStream => _chatsStream;

  // check error text changes
  final _errorTextStreamController = StreamController<String>();
  StreamSubscription<String>? _errorTextStreamSubscription;
  Stream<String>? _errorTextStream;
  Stream<String>? get errorTextStream => _errorTextStream;

  final _fullChatsList = <ChatModel>[];

  // is used to display status for user
  bool _loading = false;
  String _searchText = '';
  String _errorText = '';
  String? _tag;
  String get errorText => _errorText;
  bool get loading => _loading;

  ChatsCubit() : super(ChatsState(currentUser: null)) {
    _initialize();
  }

  Future<void> _initialize() async {
    _loading = true;
    emit(state.copyWith(currentUser: null));
    UserModel? currentUser;

    while (true) {
      currentUser = await _userDataProvider.getUserFromFireBase(
          userId: _authDataProvider.getCurrentUserUID());

      if (currentUser != null) break;
    }

    // load current language code
    _tag = await _languageProvider.getLanguageCode();

    _loading = false;
    // load current user state
    emit(state.copyWith(currentUser: currentUser));

    // check changes in chats
    _chatsStream = _chatDataProveder
        .getChatsStreamFromFirestore(userId: currentUser.userId)
        .asBroadcastStream();
    _chatsStreamSubscriprion = _chatsStream?.listen(
      (snapshot) {
        _fullChatsList.clear();

        for (var chat in snapshot.docs) {
          final chatModel = ChatModel.fromJson(chat.data());
          _fullChatsList.add(chatModel);
        }
      },
    );

    // check when error text changes
    _errorTextStream = _errorTextStreamController.stream.asBroadcastStream();
    _errorTextStreamSubscription = _errorTextStream?.listen((value) {
      _errorText = value;
    });
  }

  // create new chat
  Future<bool> createNewChat({required String userLogin}) async {
    try {
      // show loading
      _loading = true;
      emit(state.copyWith());

      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // stop if is's current user
      if (userLogin == currentUser.userLogin) {
        throw ('This\'s your Login');
      }

      // user we want to contact
      UserModel? contactUser = await _userDataProvider
          .getUserByLoginFromFireBase(userLogin: userLogin);

      // stop if user doesn't exist
      if (contactUser == null) {
        throw ('User with this Login doesn\'t exist');
      }

      // check if chat exists
      final chatExist = await _chatDataProveder.chatExists(
          userId: currentUser.userId, chatId: contactUser.userId);

      if (chatExist) {
        throw ('This chat already exists');
      }

      // create chat model for contact user
      ChatModel contactUserChat = ChatModel(
        chatId: currentUser.userId,
        chatName: currentUser.userName,
        chatContactUserId: currentUser.userId,
        chatImageUrl: currentUser.userImageUrl,
        isChatContactUserOline: currentUser.isOnline,
        lastMessage: '',
        unreadMessagesCount: 0,
        chatCreatedTime: DateTime.now(),
        lastMessageTime: DateTime.now(),
      );

      // create chat model for current user
      ChatModel currentUserChat = ChatModel(
        chatId: contactUser.userId,
        chatName: contactUser.userName,
        chatContactUserId: contactUser.userId,
        chatImageUrl: contactUser.userImageUrl,
        isChatContactUserOline: contactUser.isOnline,
        lastMessage: '',
        unreadMessagesCount: 0,
        chatCreatedTime: DateTime.now(),
        lastMessageTime: DateTime.now(),
      );

      // add chat to current user and contact user
      await _chatDataProveder.addChatToFirebase(
          userId: currentUser.userId, chatModel: currentUserChat);
      await _chatDataProveder.addChatToFirebase(
          userId: contactUser.userId, chatModel: contactUserChat);

      _setTextError('');
      return true;
    } catch (e) {
      _setTextError('$e');
      return false;
    } finally {
      // hide loading
      _loading = false;
      emit(state.copyWith());
    }
  }

  // show chat
  Future<ChatConfiguration?> showChat({ required String contactUserId, required ChatModel chatModel, required XFile? imageToSend, }) async {
    final contactUser =
        await _userDataProvider.getUserFromFireBase(userId: contactUserId);

    // stop if contact user doesn't exist
    if (contactUser == null) return null;

    final chatConfiguration = ChatConfiguration(
      contactUser: contactUser,
      chat: chatModel.copyWith(chatImageUrl: contactUser.userImageUrl),
      imageToSend: imageToSend,
    );

    return chatConfiguration;
  }

  Future<void> deleteChatForBoth({required ChatModel chatModel}) async {
    try {
      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // delete messages
      _messageDataProveder.deleteAllMessagesFromFirebase(
          userId: currentUser.userId, chatId: chatModel.chatId);
      _messageDataProveder.deleteAllMessagesFromFirebase(
          userId: chatModel.chatContactUserId, chatId: currentUser.userId);

      // delete chats
      await _chatDataProveder.deleteChatFromFirebase(
          userId: currentUser.userId, chatId: chatModel.chatId);
      await _chatDataProveder.deleteChatFromFirebase(
          userId: chatModel.chatContactUserId, chatId: currentUser.userId);
    } catch (e) {
      _setTextError('$e');
    }
  }

  Future<void> deleteChatForCurrentUser({required ChatModel chatModel}) async {
    try {
      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // delete message
      _messageDataProveder.deleteAllMessagesFromFirebase(
          userId: currentUser.userId, chatId: chatModel.chatId);

      // delete chat
      await _chatDataProveder.deleteChatFromFirebase(
          userId: currentUser.userId, chatId: chatModel.chatId);
    } catch (e) {
      _setTextError('$e');
    }
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
      return DateFormat("dd.MM.yyyy", _tag).format(dateTime);
    } else if (dateTime.day != DateTime.now().day) {
      return DateFormat("MMM d", _tag).format(dateTime);
    }

    // default format
    return DateFormat("hh:mm", _tag).format(dateTime);
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
