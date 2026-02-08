class Status {
  final String id;
  final String userName;
  final String? avatarUrl;
  final String? statusImageUrl;
  final DateTime timestamp;
  final bool isViewed;
  final bool isMuted;

  Status({
    required this.id,
    required this.userName,
    this.avatarUrl,
    this.statusImageUrl,
    required this.timestamp,
    this.isViewed = false,
    this.isMuted = false,
  });
}
