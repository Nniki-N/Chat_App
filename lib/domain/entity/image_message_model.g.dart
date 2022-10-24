// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageMessageModel _$ImageMessageModelFromJson(Map<String, dynamic> json) =>
    ImageMessageModel(
      messageId: json['message_id'] as String,
      imageUrl: json['image_url'] as String,
      senderId: json['sender_id'] as String,
      messageTime: DateTime.parse(json['message_time'] as String),
      isEdited: json['is_edited'] as bool?,
    );

Map<String, dynamic> _$ImageMessageModelToJson(ImageMessageModel instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'image_url': instance.imageUrl,
      'sender_id': instance.senderId,
      'message_time': instance.messageTime.toIso8601String(),
      'is_edited': instance.isEdited,
    };
