
class UserModel {
  final String uid;
  final String userName;
  final List contacts;
  final List chats;
  final bool isOnline;
  final String lastSeen;
  final bool isLoggedIn;

  UserModel({
    required this.uid,
    required this.userName,
    this.contacts = const [],
    this.chats = const [],
    this.isOnline = true,
    this.lastSeen = '',
    this.isLoggedIn = false,
  });

  UserModel copyWith({
    String? uid,
    String? userName,
    List? contacts,
    List? chats,
    bool? isOnline,
    String? lastSeen,
    bool? isLoggedIn,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      contacts: contacts ?? this.contacts,
      chats: chats ?? this.chats,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
