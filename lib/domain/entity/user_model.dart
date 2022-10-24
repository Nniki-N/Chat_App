// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserModel {
  final String userId;
  final String userEmail;
  final String userName;
  final String userLogin;
  final String? userImageUrl;
  final bool isOnline;
  final DateTime lastSeen;

  UserModel({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userLogin,
    this.userImageUrl,
    this.isOnline = true,
    DateTime? lastSeen,
  }) : this.lastSeen = lastSeen ?? DateTime.now();

  UserModel copyWith({
    String? userId,
    String? userEmail,
    String? userName,
    String? userLogin,
    String? userImageUrl,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userLogin: userLogin ?? this.userLogin,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
