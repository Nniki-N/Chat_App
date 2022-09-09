// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class User {
  final String uid;
  final String userName;
  final String email;
  final String password;
  final List contacts;
  final List chats;
  final bool status;
  final String lastSeen;

  User({
    required this.uid,
    required this.userName,
    required this.email,
    required this.password,
    this.contacts = const [],
    this.chats = const [],
    this.status = true,
    this.lastSeen = '',
  });

  User copyWith({
    String? uid,
    String? userName,
    String? email,
    String? password,
    List? contacts,
    List? chats,
    bool? status,
    String? lastSeen,
  }) {
    return User(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      contacts: contacts ?? this.contacts,
      chats: chats ?? this.chats,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
