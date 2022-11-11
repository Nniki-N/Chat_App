class FirestoreConstants {
  // collections
  static const pathUserCollection = 'users';
  static const pathChatCollection = 'chats';
  static const pathMessageCollection = 'messages';

  // user data fields
  static const userId = 'user_id';
  static const userEmail = 'user_email';
  static const userName = 'user_name';
  static const userLogin = 'user_login';
  static const userImageUrl = 'user_image_url';
  static const isOnline = 'is_online';
  static const lastSeen = 'last_seen';

  // chat data fields
  static const chatId = 'chat_id';
  static const chatName = 'chat_name';
  static const chatContactId = 'chat_contact_id';
  static const chatImageUrl = 'chat_image_url';
  static const lastMessage = 'last_message';
  static const unreadMessageCount = 'unread_messages_count';
  static const lastMessageTime = 'last_message_time';
  static const chatCreatedTime = 'chat_created_time';
  
  // message data fields
  static const message = 'message';
  static const senderId = 'sender_id';
  static const messageTime = 'message_time';
  static const messageImageUrl = 'message_image_url';
}