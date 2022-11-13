
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:image_picker/image_picker.dart';

class ChatConfiguration {
  UserModel contactUser;
  ChatModel chat;
  XFile? imageToSend;

  ChatConfiguration({
    required this.contactUser,
    required this.chat,
    required this.imageToSend,
  });
}