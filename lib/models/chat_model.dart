class Chat {
  final String id;
  final String name;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isUnread;
  final int unreadCount;
  final bool isGroup;
  final bool isMuted;
  final bool isPinned;
  final bool isOnline;

  Chat({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isUnread = false,
    this.unreadCount = 0,
    this.isGroup = false,
    this.isMuted = false,
    this.isPinned = false,
    this.isOnline = false,
  });
}
