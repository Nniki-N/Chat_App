// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessageModel _$TextMessageModelFromJson(Map<String, dynamic> json) =>
    TextMessageModel(
      messageId: json['message_id'] as String,
      message: json['message'] as String,
      senderId: json['sender_id'] as String,
      messageTime: DateTime.parse(json['message_time'] as String),
      isEdited: json['is_edited'] as bool?,
    );

Map<String, dynamic> _$TextMessageModelToJson(TextMessageModel instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'message': instance.message,
      'sender_id': instance.senderId,
      'message_time': instance.messageTime.toIso8601String(),
      'is_edited': instance.isEdited,
    };
