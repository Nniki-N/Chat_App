// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['user_id'] as String,
      userEmail: json['user_email'] as String,
      userName: json['user_name'] as String,
      userLogin: json['user_login'] as String,
      userImageUrl: json['user_image_url'] as String?,
      isOnline: json['is_online'] as bool? ?? true,
      lastSeen: json['last_seen'] == null
          ? null
          : DateTime.parse(json['last_seen'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_email': instance.userEmail,
      'user_name': instance.userName,
      'user_login': instance.userLogin,
      'user_image_url': instance.userImageUrl,
      'is_online': instance.isOnline,
      'last_seen': instance.lastSeen.toIso8601String(),
    };
