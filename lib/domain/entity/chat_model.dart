// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ChatModel {
  final String chatId;
  final String chatContactId;

  ChatModel({
    required this.chatId,
    required this.chatContactId,
  });

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}
