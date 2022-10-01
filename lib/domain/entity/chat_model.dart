// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ChatModel {
  final String chatId;
  final String chatName;
  final String? chatImageUrl;
  final String chatContactId;
  final String lastMessage;
  final int unreadMessagesCount;
  final DateTime lastMessageTime;

  ChatModel({
    required this.chatId,
    required this.chatName,
    this.chatImageUrl,
    required this.chatContactId,
    required this.lastMessage,
    required this.unreadMessagesCount,
    required this.lastMessageTime,
  });
  
  ChatModel copyWith({
    String? chatId,
    String? chatName,
    String? chatImageUrl,
    String? chatContactId,
    String? lastMessage,
    int? unreadMessagesCount,
    DateTime? lastMessageTime,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      chatName: chatName ?? this.chatName,
      chatImageUrl: chatImageUrl ?? this.chatImageUrl,
      chatContactId: chatContactId ?? this.chatContactId,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}
