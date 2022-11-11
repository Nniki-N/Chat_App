// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:typed_data';

import 'package:chat_app/domain/data_poviders/auth_data_provider.dart';
import 'package:chat_app/domain/data_poviders/image_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:chat_app/domain/data_poviders/chat_data_provider.dart';
import 'package:chat_app/domain/data_poviders/message_data_provider.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/domain/entity/message_model.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:chat_app/ui/screens/chat_screen/chat_date_separator.dart';
import 'package:chat_app/ui/screens/chat_screen/message_item.dart';
import 'package:chat_app/ui/screens/chat_screen/my_message_item.dart';
import 'package:uuid/uuid.dart';

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
  final _imageProvider = ImagesProvider();

  // stream for messages
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _messagesStreamSubscription;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _messagesStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get messagesStream =>
      _messagesStream;

  // stream for contact user
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _contactUserStreamSubscription;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _contactUserStream;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? get contactUserStream =>
      _contactUserStream;

  final _messageIds = <String>{};
  final _messagesList = <MessageModel>[];
  Iterable<MessageModel> get messagesList sync* {
    for (var message in _messagesList) {
      yield message;
    }
  }

  final messageFieldController = TextEditingController();
  bool _isMessageEditing = false;
  String _editingMessageId = '';
  bool get isMessageEditing => _isMessageEditing;

  String? _messageImageUrl;
  XFile? _imageToSend;
  Uint8List? _imageToSendInUint8List;
  bool _isImageSending = false;

  bool get isImageSending => _isImageSending;
  XFile? get imageToSend => _imageToSend;
  Uint8List? get imageToSendInUint8List => _imageToSendInUint8List;
  String? get messageImageUrl => _messageImageUrl;

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
    await _chatDataProveder.updateChatInFirebase(
        userId: currentUser.userId, chatModel: state.currentChat);

    // listen for contac user status
    _contactUserStream = _userDataProvider.getUserStreamFromFiebase(
        userId: state.currentChat.chatContactUserId);
    _contactUserStreamSubscription = _contactUserStream?.listen((snapshot) {
      // ckeck if contact user exists
      final data = snapshot.data();
      if (data == null) return;

      final contactUser = UserModel.fromJson(data);

      // update state
      emit(state.copyWith(
        currentChat: state.currentChat
            .copyWith(isChatContactUserOline: contactUser.isOnline),
      ));

      // update chat in firebase
      _chatDataProveder.updateChatInFirebase(
          userId: currentUser.userId, chatModel: state.currentChat);
    });

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
            // if message was added
            if (_messageIds.contains(snapshot.docs[i].id)) continue;

            final messageModel = MessageModel.fromJson(snapshot.docs[i].data());
            _messageIds.add(snapshot.docs[i].id);
            _messagesList.insert(0, messageModel);
          }
        } else {
          // check if message ixists
          final messageJson = snapshot.docChanges.last.doc.data();
          if (messageJson == null) return;

          final messageId = snapshot.docChanges.last.doc.id;

          // check if message was edded
          if (_messageIds.contains(messageId)) return;

          final messageModel =
              MessageModel.fromJson(messageJson).copyWith(messageId: messageId);

          _messageIds.add(messageId);
          _messagesList.insert(0, messageModel);
        }
      },
    );

    emit(state.copyWith());
  }

  Future<void> chooseImageToSendFromGallery() async {
    final imagePicker = ImagePicker();

    _imageToSend = await imagePicker.pickImage(source: ImageSource.gallery);
    _imageToSendInUint8List = await _imageToSend?.readAsBytes();
    _isImageSending = true;
    emit(state.copyWith());
  }

  void cancelImageSending() {
    _messageImageUrl = null;
    _imageToSend = null;
    _imageToSendInUint8List = null;
    _isImageSending = false;
    emit(state.copyWith());
  }

  // send message
  Future<void> sendMessage({required String text}) async {
    final currentUser = state.currentUser;

    // stop if current user absents
    if (currentUser == null) return;

    // edit message if message is in editing
    if (_isMessageEditing) {
      final messageModel = await _messageDataProveder.getMessageFromFirebase(
        userId: currentUser.userId,
        chatId: state.currentChat.chatId,
        messageId: _editingMessageId,
      );

      // stop if message doesn't exist
      if (messageModel == null) {
        // clear message edititng status
        _isMessageEditing = false;
        _editingMessageId = '';
        return;
      }

      await editMessage(messageModel: messageModel, newText: text);

      return;
    }

    // upload image in firebase if it is sending
    final randomMessageImageId = const Uuid().v4();
    if (_isImageSending) {
      _messageImageUrl = await _imageProvider.setImageInFirebase(
        imageFile: _imageToSend,
        imageId: randomMessageImageId,
      );
    }

    final randomMessageId = const Uuid().v4();
    final messageModel = MessageModel(
      messageId: randomMessageId,
      message: text,
      messageImageId: _isImageSending ? randomMessageImageId : null,
      messageImageUrl: _messageImageUrl,
      senderId: currentUser.userId,
      messageTime: DateTime.now(),
      isEdited: false,
    );

    // send new messages
    await _messageDataProveder.addMessageToFirebase(
      userId: currentUser.userId,
      chatId: state.currentChat.chatId,
      messageId: randomMessageId,
      messageModel: messageModel,
    );
    await _messageDataProveder.addMessageToFirebase(
      userId: state.currentChat.chatContactUserId,
      chatId: currentUser.userId,
      messageId: randomMessageId,
      messageModel: messageModel,
    );

    cancelImageSending();

    // current user chat
    final currentUserChat = await _chatDataProveder.getChatFromFirebase(
      userId: currentUser.userId,
      chatId: state.currentChat.chatId,
    );

    // contact user chat
    final contactUserChat = await _chatDataProveder.getChatFromFirebase(
      userId: state.currentChat.chatContactUserId,
      chatId: currentUser.userId,
    );

    // update current user chat
    if (currentUserChat != null) {
      _chatDataProveder.updateChatInFirebase(
        userId: currentUser.userId,
        chatModel: currentUserChat.copyWith(
          lastMessage: text,
          lastMessageTime: DateTime.now(),
        ),
      );
    }

    // update conntact user chat
    if (contactUserChat != null) {
      _chatDataProveder.updateChatInFirebase(
        userId: state.currentChat.chatContactUserId,
        chatModel: contactUserChat.copyWith(
          lastMessage: text,
          lastMessageTime: DateTime.now(),
          unreadMessagesCount: contactUserChat.unreadMessagesCount + 1,
        ),
      );
    } else {
      // create new chat for contact user if contact user chat was deleted
      _chatDataProveder.addChatToFirebase(
        userId: state.currentChat.chatContactUserId,
        chatModel: ChatModel(
          chatId: currentUser.userId,
          chatName: currentUser.userName,
          chatContactUserId: currentUser.userId,
          isChatContactUserOline: true,
          chatCreatedTime: currentUserChat?.chatCreatedTime ?? DateTime.now(),
          lastMessage: text,
          lastMessageTime: DateTime.now(),
          unreadMessagesCount: 1,
        ),
      );
    }
  }

  // edit message
  Future<void> editMessage({
    required MessageModel messageModel,
    required String newText,
  }) async {
    final currentUser = await _userDataProvider.getUserFromFireBase(
        userId: _authDataProvider.getCurrentUserUID());

    // stop if current user absents
    if (currentUser == null) {
      // clear message edititng status
      changeEditingStatus(isEditing: false);
      return;
    }

    // if nothing was changed
    if (messageModel.message == newText) {
      // clear message edititng status
      changeEditingStatus(isEditing: false);
      return;
    }

    // update message in the list
    final index = _messagesList
        .indexWhere((element) => element.messageId == messageModel.messageId);
    if (index != -1) {
      _messagesList[index] =
          _messagesList[index].copyWith(isEdited: true, message: newText);
    }

    // set new text and edited status
    await _messageDataProveder.updateMessageInFirebase(
      userId: currentUser.userId,
      chatId: state.currentChat.chatId,
      textMessageModel: messageModel.copyWith(message: newText, isEdited: true),
    );

    // update chats data if it is first message
    if (_messagesList.first.messageId == messageModel.messageId) {
      // current user chat
      final currentUserChat = await _chatDataProveder.getChatFromFirebase(
        userId: currentUser.userId,
        chatId: state.currentChat.chatId,
      );

      // contact user chat
      final contactUserChat = await _chatDataProveder.getChatFromFirebase(
        userId: state.currentChat.chatContactUserId,
        chatId: currentUser.userId,
      );

      // update current user chat
      if (currentUserChat != null) {
        _chatDataProveder.updateChatInFirebase(
          userId: currentUser.userId,
          chatModel: currentUserChat.copyWith(
            lastMessage: newText,
          ),
        );
      }

      // update conntact user chat
      if (contactUserChat != null) {
        _chatDataProveder.updateChatInFirebase(
          userId: state.currentChat.chatContactUserId,
          chatModel: contactUserChat.copyWith(
            lastMessage: newText,
          ),
        );
      }
    }

    // clear message edititng status
    messageFieldController.clear();
    changeEditingStatus(isEditing: false);
  }

  // set stauts of message editing
  void changeEditingStatus({required bool isEditing, String messageId = ''}) {
    _editingMessageId = messageId;
    _isMessageEditing = isEditing;
    emit(state.copyWith());
  }

  // delete message
  Future<void> deleteMessage({
    required String messageId,
    required String? messageImageId,
  }) async {
    if (messageId.isEmpty) return;

    final currentUser = await _userDataProvider.getUserFromFireBase(
        userId: _authDataProvider.getCurrentUserUID());

    // stop if current user absents
    if (currentUser == null) return;

    // if message is first in list, update chat date also
    if (messageId == _messagesList.first.messageId) {
      _messagesList.removeAt(0);

      // update data of current and contact user chats
      if (_messagesList.isEmpty) {
        // update current user chat
        _chatDataProveder.updateChatInFirebase(
          userId: currentUser.userId,
          chatModel: state.currentChat.copyWith(
            lastMessage: '',
            lastMessageTime: DateTime.now(),
          ),
        );

        final contactUserChat = await _chatDataProveder.getChatFromFirebase(
          userId: state.currentChat.chatContactUserId,
          chatId: currentUser.userId,
        );

        // stop if contact user chat absents
        if (contactUserChat == null) return;

        // update contact user chat
        _chatDataProveder.updateChatInFirebase(
          userId: state.currentChat.chatContactUserId,
          chatModel: contactUserChat.copyWith(
            lastMessage: '',
            lastMessageTime: DateTime.now(),
          ),
        );
      } else {
        // update current user chat
        _chatDataProveder.updateChatInFirebase(
          userId: currentUser.userId,
          chatModel: state.currentChat.copyWith(
            lastMessage: _messagesList.first.message,
            lastMessageTime: _messagesList.first.messageTime,
          ),
        );

        final contactUserChat = await _chatDataProveder.getChatFromFirebase(
          userId: state.currentChat.chatContactUserId,
          chatId: currentUser.userId,
        );

        // stop if contact user chat absents
        if (contactUserChat == null) return;

        // update contact user chat
        _chatDataProveder.updateChatInFirebase(
          userId: state.currentChat.chatContactUserId,
          chatModel: contactUserChat.copyWith(
            lastMessage: '',
            lastMessageTime: DateTime.now(),
          ),
        );
      }
    } else {
      final index =
          _messagesList.indexWhere((message) => message.messageId == messageId);
      _messagesList.removeAt(index);
    }

    // delete message for current user
    await _messageDataProveder.deleteMessage(
      userId: currentUser.userId,
      chatId: state.currentChat.chatId,
      messageId: messageId,
    );

    // delete message for contact user
    await _messageDataProveder.deleteMessage(
      userId: state.currentChat.chatId,
      chatId: currentUser.userId,
      messageId: messageId,
    );

    // delete message image if it exists
    await _imageProvider.deleteImageFromFirebase(
        imageId: messageImageId);
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
            ChatDateSeparator(
                date: getMessageDate(date: messageModel.messageTime)),
            MyMessageItem(
              messageModel: messageModel,
            ),
          ],
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatDateSeparator(
                date: getMessageDate(date: messageModel.messageTime)),
            MessageItem(
              messageModel: messageModel,
            ),
          ],
        );
      }
    }

    // return message
    if (messageModel.senderId == currentUser.userId) {
      return MyMessageItem(
        messageModel: messageModel,
      );
    } else {
      return MessageItem(
        messageModel: messageModel,
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
  String getMessageDate({required DateTime date}) {
    if (date.year != DateTime.now().year) {
      return DateFormat("d MMM yyyy").format(date);
    } else {
      return DateFormat("d MMM").format(date);
    }
  }

  // get message time in gormat hours and minutes
  String getMessageTime({required DateTime time}) =>
      DateFormat("hh:mm").format(time);

  @override
  Future<void> close() async {
    await _messagesStreamSubscription?.cancel();
    await _contactUserStreamSubscription?.cancel();
    return super.close();
  }
}
