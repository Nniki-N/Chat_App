
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/domain/entity/user_model.dart';

class ChatConfiguration {
  UserModel contactUser;
  ChatModel chat;
  ChatConfiguration({
    required this.contactUser,
    required this.chat,
  });
}