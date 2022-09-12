// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MessageModel {
  final String messageId;
  final String message;
  final String senderId;
  final DateTime time;

  MessageModel({
    required this.messageId,
    required this.message,
    required this.senderId,
    required this.time,
  });

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
