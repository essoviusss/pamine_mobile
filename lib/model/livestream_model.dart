class LiveStream {
  String title;
  String image;
  String uid;
  String username;
  final startedAt;
  int viewers;
  String channelId;

  LiveStream({
    required this.title,
    required this.image,
    required this.uid,
    required this.username,
    required this.viewers,
    required this.channelId,
    required this.startedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'uid': uid,
      'username': username,
      'viewers': viewers,
      'channelId': channelId,
      'startedAt': startedAt,
    };
  }

  factory LiveStream.fromMap(Map<String, dynamic> map) {
    return LiveStream(
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      viewers: map['viewers']?.toInt() ?? 0,
      channelId: map['channelId'] ?? '',
      startedAt: map['startedAt'] ?? '',
    );
  }
}
