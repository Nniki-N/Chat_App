// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MessageModel {
  final String messageId;
  final String message;
  final String? messageImageId;
  final String? messageImageUrl;
  final String senderId;
  final DateTime messageTime;
  final bool? isEdited;

  MessageModel({
    required this.messageId,
    required this.message,
    required this.messageImageId,
    required this.messageImageUrl,
    required this.senderId,
    required this.messageTime,
    required this.isEdited,
  });
  
  MessageModel copyWith({
    String? messageId,
    String? message,
    String? messageImageId,
    String? messageImageUrl,
    String? senderId,
    DateTime? messageTime,
    bool? isEdited,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      messageImageId: messageImageId ?? this.messageImageId,
      messageImageUrl: messageImageUrl ?? this.messageImageUrl,
      senderId: senderId ?? this.senderId,
      messageTime: messageTime ?? this.messageTime,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);


}
