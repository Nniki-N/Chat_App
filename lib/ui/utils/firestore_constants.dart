class FirestoreConstants {
  // collections
  static const pathUserCollection = 'users';
  static const pathChatCollection = 'chats';
  static const pathMessageCollection = 'messages';

  // user data fields
  static const userId = 'user_id';
  static const userName = 'user_name';
  static const userImageUrl = 'user_image_url';
  static const isOnline = 'is_online';
  static const lastSeen = 'last_seen';

  // chat data fields
  static const chatId = 'chat_id';
  static const chatName = 'chat_name';
  static const chatContactId = 'chat_contact_id';
  static const unreadMessageCount = 'unread_messages_count';
  static const lastMessageTime = 'last_message_time';
  
  // message data fields
  static const messageId = 'message_id';
  static const message = 'message';
  static const senderId = 'sender_id';
  static const messageTime = 'message_time';
}