// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      chatId: json['chat_id'] as String,
      chatName: json['chat_name'] as String,
      chatImageUrl: json['chat_image_url'] as String?,
      chatContactId: json['chat_contact_id'] as String,
      lastMessage: json['last_message'] as String,
      unreadMessagesCount: json['unread_messages_count'] as int,
      lastMessageTime: DateTime.parse(json['last_message_time'] as String),
      chatCreatedTime: DateTime.parse(json['chat_created_time'] as String),
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'chat_id': instance.chatId,
      'chat_name': instance.chatName,
      'chat_image_url': instance.chatImageUrl,
      'chat_contact_id': instance.chatContactId,
      'last_message': instance.lastMessage,
      'unread_messages_count': instance.unreadMessagesCount,
      'last_message_time': instance.lastMessageTime.toIso8601String(),
      'chat_created_time': instance.chatCreatedTime.toIso8601String(),
    };
