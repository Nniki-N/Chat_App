// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ChatModel {
  final String chatId;
  final String chatName;
  final String? chatImageUrl;
  final String chatContactUserId;
  final bool isChatContactUserOline;
  final String lastMessage;
  final int unreadMessagesCount;
  final DateTime lastMessageTime;
  final DateTime chatCreatedTime;

  ChatModel({
    required this.chatId,
    required this.chatName,
    this.chatImageUrl,
    required this.chatContactUserId,
    required this.isChatContactUserOline,
    required this.lastMessage,
    required this.unreadMessagesCount,
    required this.lastMessageTime,
    required this.chatCreatedTime,
  });

  ChatModel copyWith({
    String? chatId,
    String? chatName,
    String? chatImageUrl,
    String? chatContactUserId,
    bool? isChatContactUserOline,
    String? lastMessage,
    int? unreadMessagesCount,
    DateTime? lastMessageTime,
    DateTime? chatCreatedTime,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      chatName: chatName ?? this.chatName,
      chatImageUrl: chatImageUrl ?? this.chatImageUrl,
      chatContactUserId: chatContactUserId ?? this.chatContactUserId,
      isChatContactUserOline:
          isChatContactUserOline ?? this.isChatContactUserOline,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      chatCreatedTime: chatCreatedTime ?? this.chatCreatedTime,
    );
  }

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}
