// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserModel {
  final String userId;
  final String userName;
  final bool isOnline;
  final DateTime lastSeen;

  UserModel({
    required this.userId,
    required this.userName,
    this.isOnline = true,
    DateTime? lastSeen,
  }) : this.lastSeen = lastSeen ?? DateTime.now();

  UserModel copyWith({
    String? userId,
    String? userName,
    bool? isOnline,
    DateTime? lastSeen,
    Map<String, dynamic>? chats,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
