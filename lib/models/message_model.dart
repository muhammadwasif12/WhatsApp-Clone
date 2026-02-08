class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final bool isRead;
  final String? imageUrl;
  final String? audioUrl;
  final int? audioDuration;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.isRead = false,
    this.imageUrl,
    this.audioUrl,
    this.audioDuration,
  });
}
