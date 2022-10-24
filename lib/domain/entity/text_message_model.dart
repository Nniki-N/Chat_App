// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'text_message_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TextMessageModel {
  final String messageId;
  final String message;
  final String senderId;
  final DateTime messageTime;
  final bool? isEdited;

  TextMessageModel({
    required this.messageId,
    required this.message,
    required this.senderId,
    required this.messageTime,
    required this.isEdited,
  });

  TextMessageModel copyWith({
    String? messageId,
    String? message,
    String? senderId,
    DateTime? messageTime,
    bool? isEdited,
  }) {
    return TextMessageModel(
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      messageTime: messageTime ?? this.messageTime,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  Map<String, dynamic> toJson() => _$TextMessageModelToJson(this);

  factory TextMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TextMessageModelFromJson(json);
}
