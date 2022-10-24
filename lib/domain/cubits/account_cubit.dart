// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:chat_app/domain/data_poviders/chat_data_provider.dart';
import 'package:chat_app/domain/data_poviders/message_data_provider.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/domain/data_poviders/auth_data_provider.dart';
import 'package:chat_app/domain/data_poviders/image_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:chat_app/domain/entity/user_model.dart';

class AccountState {
  UserModel? currentUser;
  AccountState({
    required this.currentUser,
  });

  AccountState copyWith({
    UserModel? currentUser,
  }) {
    return AccountState(
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class AccountCubit extends Cubit<AccountState> {
  final _authDataProvider = AuthDataProvider();
  final _userDataProvider = UserDataProvider();
  final _chatDataProveder = ChatDataProvider();
  final _messageDataProveder = MessageDataProvider();
  final _imageProvider = ImagesProvider();

  String _errorText = '';
  String get errorText => _errorText;

  // check error text changes
  final _errorTextStreamController = StreamController<String>();
  StreamSubscription<String>? _errorTextStreamSubscription;
  Stream<String>? _errorTextStream;
  Stream<String>? get errorTextStream => _errorTextStream;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _chatsStreamSubscription;

  AccountCubit() : super(AccountState(currentUser: null)) {
    _initialize();
  }

  Future<void> _initialize() async {
    emit(state.copyWith(
        currentUser: await _userDataProvider.getUserFromFireBase(
            userId: _authDataProvider.getCurrentUserUID())));

    // check error text changes
    _errorTextStream = _errorTextStreamController.stream.asBroadcastStream();
    _errorTextStreamSubscription = _errorTextStream?.listen((value) {
      _errorText = value;
    });
  }

  // delete account and all user data with chats
  Future<void> deleteUserWithEmailAndPassword({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      final currentUser = state.currentUser;
      final userToDelete = await _userDataProvider.getUserByEmailFromFireBase(
          userEmail: userEmail);

      // stop if current user absents
      if (currentUser == null) {
        _setTextError('You aren\'t signed in');
        return;
      }

      // if user to delete doesn't exist
      if (userToDelete == null) {
        _setTextError('No user found for that email.');
        return;
      }

      // if current user try delete another user
      if (currentUser.userEmail != userToDelete.userEmail) {
        _setTextError('This isn\'t your email');
        return;
      }

      // delete account
      await _authDataProvider.deleteUser(
          email: userEmail, password: userPassword);

      // clear user data
      _userDataProvider.deleteUserFromFirebase(userId: currentUser.userId);

      // delte all user chats and chat with current user for everyone
      _chatsStreamSubscription = _chatDataProveder
          .getChatsStreamFromFirestore(userId: currentUser.userId)
          .listen((snapshot) async {
        for (var chat in snapshot.docs) {
          final chatModel = ChatModel.fromJson(chat.data());

          _chatDataProveder.deleteChatFromFirebase(
              userId: currentUser.userId, chatId: chatModel.chatId);
          _chatDataProveder.deleteChatFromFirebase(
              userId: chatModel.chatContactUserId, chatId: currentUser.userId);

          // delete messages
          _messageDataProveder.deleteAllMessagesFromFirebase(
              userId: currentUser.userId, chatId: chatModel.chatId);
          _messageDataProveder.deleteAllMessagesFromFirebase(
              userId: chatModel.chatContactUserId, chatId: currentUser.userId);
        }
      });

      _setTextError('');
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        default:
          _setTextError('Some error happened');
      }
    } catch (e) {
      _setTextError('Some error happened');
    }
  }

  // change user online status
  Future<void> changeUserOnlineStatus({required bool isOnline}) async {
    final currentUser = state.currentUser;

    // stop if current user absents
    if (currentUser == null) {
      _setTextError('You aren\'t signed in');
      return;
    }

    await _userDataProvider.updateUserInFirebase(
        user: currentUser.copyWith(isOnline: isOnline));
  }

  // set user image
  Future<void> setUserImage() async {
    try {
      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        _setTextError('You aren\'t signed in');
        return;
      }

      final imageUrl = await _imageProvider.setAvatarImageInFirebaseFromGallery(
          userId: currentUser.userId);

      if (imageUrl == null) return;

      emit(state.copyWith(
          currentUser: currentUser.copyWith(userImageUrl: imageUrl)));

      await _userDataProvider.updateUserInFirebase(
          user: currentUser.copyWith(userImageUrl: imageUrl));
      await _chatDataProveder.updateAllChatsAvatarsInFirebase(
          userId: currentUser.userId, userImageUrl: imageUrl);

      _setTextError('');
    } catch (e) {
      _setTextError('Some error happened');
    }
  }

  // update Profile
  Future<void> updateProfile({
    required String userName,
    required String userLogin,
  }) async {
    try {
      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        _setTextError('You aren\'t signed in');
        return;
      }

      await _userDataProvider.updateUserInFirebase(
          user: currentUser.copyWith(
        userName: userName,
        userLogin: userLogin,
      ));

      emit(state.copyWith(
          currentUser: currentUser.copyWith(
        userName: userName,
        userLogin: userLogin,
      )));
    } catch (e) {
      _setTextError('Some error happened');
    }
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
    await _chatsStreamSubscription?.cancel();
    await _errorTextStreamSubscription?.cancel();
    return super.close();
  }
}