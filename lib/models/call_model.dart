class Call {
  final String id;
  final String name;
  final String? avatarUrl;
  final DateTime timestamp;
  final bool isOutgoing;
  final bool isVideo;
  final bool isMissed;

  Call({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.timestamp,
    required this.isOutgoing,
    required this.isVideo,
    this.isMissed = false,
  });
}
