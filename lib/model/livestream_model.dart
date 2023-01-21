import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LiveStream {
  String? title;
  String? image;
  String? uid;
  String? username;
  final startedAt;
  int? viewers;
  String? channelId;
  List? category = [];

  LiveStream({
    this.title,
    this.image,
    this.uid,
    this.username,
    this.viewers,
    this.channelId,
    this.startedAt,
    this.category,
  });

  List<LiveStream> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return LiveStream(
          title: dataMap['title'],
          image: dataMap['image'],
          uid: dataMap['uid'],
          username: dataMap['username'],
          viewers: dataMap['viewers'],
          channelId: dataMap['channelId'],
          startedAt: dataMap['startedAt'],
          category: dataMap['category']);
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'uid': uid,
      'username': username,
      'viewers': viewers,
      'channelId': channelId,
      'startedAt': startedAt,
      'category': category,
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
      category: map['category'] ?? [],
    );
  }
}
