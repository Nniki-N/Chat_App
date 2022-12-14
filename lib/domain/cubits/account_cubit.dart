import 'dart:async';
import 'dart:typed_data';

import 'package:chat_app/domain/data_poviders/chat_data_provider.dart';
import 'package:chat_app/domain/data_poviders/message_data_provider.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/domain/entity/picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/domain/data_poviders/auth_data_provider.dart';
import 'package:chat_app/domain/data_poviders/image_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AccountState {
  UserModel? currentUser;
  Uint8List? userAvatar;

  AccountState({
    required this.currentUser,
    required this.userAvatar,
  });

  AccountState copyWith({
    UserModel? currentUser,
    Uint8List? userAvatar,
  }) {
    return AccountState(
      currentUser: currentUser ?? this.currentUser,
      userAvatar: userAvatar ?? this.userAvatar,
    );
  }
}

class AccountCubit extends Cubit<AccountState> {
  final _authDataProvider = AuthDataProvider();
  final _userDataProvider = UserDataProvider();
  final _chatDataProveder = ChatDataProvider();
  final _messageDataProveder = MessageDataProvider();
  final _imageProvider = ImagesProvider();

  // variables used to display response to user
  String _errorText = '';
  String get errorText => _errorText;
  bool _loading = false;
  bool get loading => _loading;

  // to check error text changes
  final _errorTextStreamController = StreamController<String>();
  StreamSubscription<String>? _errorTextStreamSubscription;
  Stream<String>? _errorTextStream;
  Stream<String>? get errorTextStream => _errorTextStream;

  // to check chats changes
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _chatsStreamSubscription;

  AccountCubit() : super(AccountState(currentUser: null, userAvatar: null)) {
    _initialize();
  }

  Future<void> _initialize() async {
    // load user
    emit(state.copyWith(
      currentUser: await _userDataProvider.getUserFromFireBase(
          userId: _authDataProvider.getCurrentUserUID()),
    ));

    // load user avatar
    await getUserAvatar();

    // notifies about any error text changes
    _errorTextStream = _errorTextStreamController.stream.asBroadcastStream();
    _errorTextStreamSubscription = _errorTextStream?.listen((value) {
      _errorText = value;
    });
  }

  // change state current user
  Future<void> setNewCurrentUser({required bool isSignedIn}) async {
    if (isSignedIn) {
      // load user
      emit(state.copyWith(
        currentUser: await _userDataProvider.getUserFromFireBase(
            userId: _authDataProvider.getCurrentUserUID()),
      ));

      // load user avatar
      await getUserAvatar();
    } else {
      emit(AccountState(currentUser: null, userAvatar: null));
    }
  }

  // delete account and all user data with chats
  Future<void> deleteUserWithEmailAndPassword({ required String userEmail, required String userPassword, }) async {
    try {
      // display loading
      _loading = true;
      emit(state.copyWith());

      final currentUser = state.currentUser;
      final userToDelete = await _userDataProvider.getUserByEmailFromFireBase(
          userEmail: userEmail);

      // stop if current user absents
      if (currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // stop if user to delete doesn't exist
      if (userToDelete == null) {
        throw ('No user found for that email.');
      }

      // stop if current user try delete another user
      if (currentUser.userEmail != userToDelete.userEmail) {
        throw ('This isn\'t your email');
      }

      // delete account from firebase
      await _authDataProvider.deleteUserFromFirebase(
          email: userEmail, password: userPassword);

      // clear user data from firebase
      await _userDataProvider.deleteUserDataFromFirebase(
          userId: currentUser.userId);

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

      await setNewCurrentUser(isSignedIn: false);

      _setTextError('');
    } on FirebaseAuthException catch (e) {
      // display special error message
      switch (e.code) {
        default:
          _setTextError('Some error happened');
      }
    } catch (e) {
      _setTextError('$e');
    } finally {
      _loading = false;
      emit(state.copyWith());
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

  // set user avatar
  Future<void> setUserAvatar() async {
    try {
      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // select image from gallery
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);

      // stop if image absents
      if (image == null) {
        _setTextError('');
        return;
      }

      // save avatar in state
      emit(state.copyWith(userAvatar: await image.readAsBytes()));

      // save avatar in firebase
      final imageUrl = await _imageProvider.saveAvatarImageInFirebase(
        userId: currentUser.userId,
        imageFile: image,
      );

      // if saving in firebase was not successful set null to state avatar and stop
      if (imageUrl == null) {
        emit(AccountState(currentUser: state.currentUser, userAvatar: null));
        return;
      }

      // convert avatar in correct format and save in database
      final imageUint8List = await image.readAsBytes();
      final picture =
          Picture(title: currentUser.userId, picture: imageUint8List);
      await _imageProvider.savePictureInDB(picture: picture);

      // set avatar url to state
      emit(state.copyWith(
          currentUser: currentUser.copyWith(userImageUrl: imageUrl)));

      // update avatar everywhere in firebase
      await _userDataProvider.updateUserInFirebase(
          user: currentUser.copyWith(userImageUrl: imageUrl));
      await _chatDataProveder.updateAllChatsAvatarsInFirebase(
          userId: currentUser.userId, userImageUrl: imageUrl);

      _setTextError('');
    } catch (e) {
      _setTextError('$e');
    }
  }

  // sdelete user avatar
  Future<void> deleteUserAvatar() async {
    try {
      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // clear user avatar url
      final newCurrentUser = UserModel(
          userId: currentUser.userId,
          userEmail: currentUser.userEmail,
          userName: currentUser.userName,
          userLogin: currentUser.userLogin,
          userImageUrl: null,
          isOnline: currentUser.isOnline,
          lastSeen: currentUser.lastSeen);

      // delete user avatar
      await _imageProvider.deletePictureFromDB(title: newCurrentUser.userId);
      await _imageProvider.deleteAvatarFromFirebase(userId: currentUser.userId);

      // delete user avatar everywhere in firebase
      _userDataProvider.updateUserInFirebase(user: newCurrentUser);
      _chatDataProveder.updateAllChatsAvatarsInFirebase(
          userId: newCurrentUser.userId, userImageUrl: null);

      _setTextError('');
      emit(AccountState(currentUser: newCurrentUser, userAvatar: null));
    } on FirebaseException catch (e) {
      // display special error message
      switch (e.code) {
        case 'object-not-found':
          _setTextError('');
          break;
        default:
          _setTextError('Some error happened');
      }
    } catch (e) {
      _setTextError('$e');
    }
  }

  // get user avatar
  Future<Uint8List?> getUserAvatar() async {
    try {
      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // load avatar from database
      Picture? picture =
          await _imageProvider.getPictureFromDB(title: currentUser.userId);

      // update state avatar and return avatar if it absents
      if (picture != null) {
        _setTextError('');
        emit(state.copyWith(userAvatar: picture.picture));
        return picture.picture;
      }

      // load avatar from firebase
      final url = await _imageProvider.loadAvatarFromFirebase(
          userId: currentUser.userId);

      if (url != null) {
        final uri = Uri.parse(url);

        // create new picure from avatar
        picture = Picture(
          title: currentUser.userId,
          picture: (await http.get(uri)).bodyBytes,
        );

        // save picture in database
        _imageProvider.savePictureInDB(picture: picture);

        // return avatar in Uint8List format
        _setTextError('');
        emit(state.copyWith(userAvatar: picture.picture));
        return picture.picture;
      } else {
        _setTextError('');
        emit(state.copyWith(userAvatar: null));
        return null;
      }
    } on FirebaseException catch (e) {
      // display special error message
      switch (e.code) {
        case 'object-not-found':
          _setTextError('');
          break;
        default:
          _setTextError('Some error happened');
      }
      emit(state.copyWith(userAvatar: null));
      return null;
    } catch (e) {
      _setTextError('$e');
      emit(state.copyWith(userAvatar: null));
      return null;
    }
  }

  // update Profile
  Future<bool> updateProfile({ required String userName, required String userLogin, }) async {
    try {
      final currentUser = state.currentUser;

      // stop if current user absents
      if (currentUser == null) {
        throw ('You aren\'t signed in');
      }

      // update user name everywhere in firebase
      await _userDataProvider.updateUserNameInFirebase(
          userId: currentUser.userId, userName: userName);
      _chatDataProveder.updateAllChatsNamesInFirebase(
          userId: currentUser.userId, chatName: userName);

      // update user login in firebase
      await _userDataProvider.updateUserLoginInFirebase(
          userId: currentUser.userId, userLogin: userLogin);

      _setTextError('');
      emit(state.copyWith(
          currentUser: currentUser.copyWith(
        userName: userName,
        userLogin: userLogin,
      )));
      return true;
    } catch (e) {
      _setTextError('$e');
      return false;
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
