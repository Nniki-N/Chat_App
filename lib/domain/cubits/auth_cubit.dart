import 'dart:async';
import 'package:chat_app/domain/data_poviders/auth_data_provider.dart';
import 'package:chat_app/domain/data_poviders/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

enum AuthState {
  initial,
  signedIn,
  signedOut,
  inProcess,
}

class AuthCubit extends Cubit<AuthState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _authDataProvider = AuthDataProvider();
  final _userDataProvider = UserDataProvider();

  // stream subscriptions
  StreamSubscription<String?>? _authStreamSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _chatsStreamSubscription;

  // check error text changes
  final _errorTextStreamController = StreamController<String>();
  StreamSubscription<String>? _errorTextStreamSubscription;
  Stream<String>? _errorTextStream;

  Stream<String>? get errorTextStream => _errorTextStream;

  // is used to display status to user
  bool _loading = false;
  String _errorText = '';
  bool get loading => _loading;
  String get errorText => _errorText;

  UserModel? _currentUser;

  AuthCubit() : super(AuthState.initial) {
    _initialize();
  }

  Future<void> _initialize() async {
    _currentUser = await _userDataProvider.getUserFromFireBase(
        userId: _authDataProvider.getCurrentUserUID());

    // check when auth status changes and notifies
    _authStreamSubscription = _authDataProvider.onAuthStateChanged.listen(
        (String? userId) => userId == null
            ? emit(AuthState.signedOut)
            : emit(AuthState.signedIn));

    // check error text changes
    _errorTextStream = _errorTextStreamController.stream.asBroadcastStream();
    _errorTextStreamSubscription = _errorTextStream?.listen((value) {
      _errorText = value;
    });
  }

  // sign in
  Future<void> signInWithEmailAndPassword({
    required String emailOrLogin,
    required String password,
  }) async {
    try {
      // show loading
      _loading = true;
      emit(AuthState.inProcess);

      if (emailOrLogin.contains('@gmail.com')) {
        // sign in with email and password
        final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: emailOrLogin,
          password: password,
        );
        final user = result.user;

        // check if sign in was successful
        final userModel = await _converFirebaseUserIntoUserModel(user: user);
        if (userModel != null) {
          // upload data of active status
          _userDataProvider.updateUserInFirebase(
              user:
                  userModel.copyWith(isOnline: true, lastSeen: DateTime.now()));

          _currentUser =
              userModel.copyWith(isOnline: true, lastSeen: DateTime.now());

          _setTextError('');
          emit(AuthState.signedIn);
        } else {
          _setTextError('No user found for that email.');
          emit(AuthState.signedOut);
        }
      } else {
        // add @ if it isn't written
        if (emailOrLogin.indexOf('@') != 0) emailOrLogin = '@$emailOrLogin';

        UserModel? userModel = await _userDataProvider
            .getUserByLoginFromFireBase(userLogin: emailOrLogin);

        // stop if user absents
        if (userModel == null) {
          _setTextError('No user found for that login.');
          emit(AuthState.signedOut);
          return;
        }

        // sign in with email and password
        final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: userModel.userEmail,
          password: password,
        );
        final user = result.user;

        // check if sign in was successful
        userModel = await _converFirebaseUserIntoUserModel(user: user);
        if (userModel != null) {
          _userDataProvider.updateUserInFirebase(
              user:
                  userModel.copyWith(isOnline: true, lastSeen: DateTime.now()));

          _currentUser =
              userModel.copyWith(isOnline: true, lastSeen: DateTime.now());

          _setTextError('');
          emit(AuthState.signedIn);
        } else {
          _setTextError('Some error happened');
          emit(AuthState.signedOut);
        }
      }
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'user-not-found':
          _setTextError('No user found for that email.');
          break;
        case 'invalid-email':
          _setTextError('Email address is written wrong');
          break;
        case 'wrong-password':
          _setTextError('Wrong password.');
          break;
        case 'user-disabled':
          _setTextError('Your account has been disabled by an administrator');
          break;
        default:
          _setTextError('Some error happened');
      }

      emit(AuthState.signedOut);
    } finally {
      // hide loading
      _loading = false;
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      // show loading
      _loading = true;
      emit(AuthState.inProcess);

      await _firebaseAuth.signOut();

      // upload data of inactive status
      _userDataProvider.updateUserInFirebase(
          user: _currentUser!
              .copyWith(isOnline: false, lastSeen: DateTime.now()));

      _setTextError('');
      emit(AuthState.signedOut);
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'user-signed-out':
          _setTextError('Invalid logout way.');
          break;
        default:
          _setTextError('Some error happened');
      }

      emit(AuthState.signedIn);
    } finally {
      // hide loading
      _loading = false;
    }
  }

  // register
  Future<void> registerWithEmailAndPassword({
    required String userName,
    required String email,
    required String userLogin,
    required String password,
  }) async {
    try {
      // show loading
      _loading = true;
      emit(AuthState.inProcess);

      // create new accaunt with email and password
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // get user from firebase firestore if user exists
      final userModel = await _converFirebaseUserIntoUserModel(
          user: user,
          userEmail: email,
          userName: userName,
          userLogin: userLogin);
      if (userModel != null) {
        // upload user's new data
        await _userDataProvider.addUserToFirebase(user: userModel);
        _currentUser = userModel;

        _setTextError('');
        emit(AuthState.signedIn);
      }
    } on FirebaseAuthException catch (e) {
      // show error message
      switch (e.code) {
        case 'email-already-exists':
          _setTextError('This email already exists.');
          break;
        case 'invalid-email':
          _setTextError('Please write your email correctly');
          break;
        case 'weak-password':
          _setTextError('Password shold be at least 6 characters.');
          break;
        default:
          _setTextError('Some error happened');
      }

      emit(AuthState.signedOut);
    } finally {
      // hide loading
      _loading = true;
    }
  }

  // // delete account and all user data with chats
  // Future<void> deleteUserWithEmailAndPassword(
  //     {required String userEmail, required String userPassword}) async {
  //   try {
  //     // show loading
  //     _loading = true;
  //     emit(AuthState.signedIn);
//
  //     final userToDelete = await _userDataProvider.getUserByEmailFromFireBase(
  //         userEmail: userEmail);
//
  //     // if user doesn't exist
  //     if (_currentUser == null) {
  //       _setTextError('You aren\'t signed in.');
  //       _loading = false;
  //       emit(AuthState.signedOut);
  //       return;
  //     }
//
  //     // if user to delete doesn't exist
  //     if (userToDelete == null) {
  //       _setTextError('No user found for that email.');
  //       _loading = false;
  //       emit(AuthState.signedIn);
  //       return;
  //     }
//
  //     // if current user try delete another user
  //     if (_currentUser!.userEmail != userToDelete.userEmail) {
  //       _setTextError('This isn\'t your email');
  //       _loading = false;
  //       emit(AuthState.signedIn);
  //       return;
  //     }
//
  //     // delete account
  //     await _authDataProvider.deleteUser(
  //         email: userEmail, password: userPassword);
//
  //     // clear user data
  //     await _userDataProvider.deleteUserFromFirebase(
  //         userId: _currentUser!.userId);
//
  //     // delte all user chats and chat with current user for everyone
  //     _chatsStreamSubscription = _chatDataProveder
  //         .getChatsStreamFromFirestore(userId: _currentUser!.userId)
  //         .listen((snapshot) async {
  //       for (var chat in snapshot.docs) {
  //         final chatModel = ChatModel.fromJson(chat.data());
//
  //         _chatDataProveder.deleteChatFromFirebase(
  //             userId: _currentUser!.userId, chatId: chatModel.chatId);
  //         _chatDataProveder.deleteChatFromFirebase(
  //             userId: chatModel.chatContactUserId,
  //             chatId: _currentUser!.userId);
//
  //         // delete messages
  //         _messageDataProveder.deleteAllMessagesFromFirebase(
  //             userId: _currentUser!.userId, chatId: chatModel.chatId);
  //         _messageDataProveder.deleteAllMessagesFromFirebase(
  //             userId: chatModel.chatContactUserId,
  //             chatId: _currentUser!.userId);
  //       }
  //     });
//
  //     _loading = false;
  //     emit(AuthState.signedOut);
  //   } on FirebaseAuthException catch (e) {
  //     // show error message
  //     switch (e.code) {
  //       default:
  //         _setTextError('Some error happened');
  //     }
//
  //     _loading = false;
  //     emit(AuthState.signedIn);
  //   } catch (e) {
  //     _setTextError('Some error happened');
  //     _loading = false;
  //     emit(AuthState.signedIn);
  //   }
  // }
//
  // // change user online status
  // Future<void> changeUserOnlineStatus({required bool isOnline}) async {
  //   // stop if current user absents
  //   if (_currentUser == null) return;
//
  //   await _userDataProvider.updateUserInFirebase(
  //       user: _currentUser!.copyWith(isOnline: isOnline));
  // }
//
  // // set user image
  // Future<void> setUserImage() async {
  //   if (_currentUser == null) {
  //     _setTextError('You aren\'t signed in');
  //     return;
  //   }
//
  //   final imageUrl = await _imageProvider.setAvatarImageInFirebaseFromGallery(
  //       userId: _authDataProvider.getCurrentUserUID());
  //   await _userDataProvider.updateUserInFirebase(
  //       user: _currentUser!.copyWith(userImageUrl: imageUrl));
  //   _currentUser = _currentUser!.copyWith(userImageUrl: imageUrl);
  //   await _chatDataProveder.updateAllChatsAvatarsInFirebase(
  //       userId: _currentUser!.userId, userImageUrl: imageUrl);
//
  //   _setTextError('');
  //   emit(AuthState.signedIn);
  // }
//
  // // update Profile
  // Future<void> updateProfile({required String userName, required String userLogin}) async {
  //   if (currentUser == null) return;
//
  //   await _userDataProvider.updateUserInFirebase(
  //       user: currentUser!.copyWith(
  //     userName: userName,
  //     userLogin: userLogin,
  //   ));
//
  //   _currentUser = currentUser!.copyWith(
  //     userName: userName,
  //     userLogin: userLogin,
  //   );
  // }

  // conver firebase user date into UserModel
  Future<UserModel?> _converFirebaseUserIntoUserModel({
    required User? user,
    String userEmail = '',
    String userName = '',
    String userLogin = '',
  }) async {
    if (user == null) return null;

    // get UserModel from firebase firestore
    final result = await _userDataProvider.getUserFromFireBase(
      userId: user.uid,
    );
    if (result != null) return result;

    // return new UserModel if it absent in firebase firestore
    return UserModel(
        userId: user.uid,
        userEmail: userEmail,
        userName: userName,
        userLogin: userLogin);
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
    await _authStreamSubscription?.cancel();
    await _chatsStreamSubscription?.cancel();
    await _errorTextStreamSubscription?.cancel();
    return super.close();
  }
}
