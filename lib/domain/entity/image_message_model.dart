// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'image_message_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ImageMessageModel {
  final String messageId;
  final String imageUrl;
  final String senderId;
  final DateTime messageTime;
  final bool? isEdited;

  ImageMessageModel({
    required this.messageId,
    required this.imageUrl,
    required this.senderId,
    required this.messageTime,
    required this.isEdited,
  });

  ImageMessageModel copyWith({
    String? messageId,
    String? imageUrl,
    String? senderId,
    DateTime? messageTime,
    bool? isEdited,
  }) {
    return ImageMessageModel(
      messageId: messageId ?? this.messageId,
      imageUrl: imageUrl ?? this.imageUrl,
      senderId: senderId ?? this.senderId,
      messageTime: messageTime ?? this.messageTime,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  Map<String, dynamic> toJson() => _$ImageMessageModelToJson(this);

  factory ImageMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageMessageModelFromJson(json);

}
