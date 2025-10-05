import 'package:cloud_firestore/cloud_firestore.dart';

class HeartReaction {
  final String id;
  final String postId;
  final String userId;
  final String userDisplayName;
  final String? userPhotoURL;
  final Timestamp heartedAt;

  HeartReaction({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userDisplayName,
    this.userPhotoURL,
    required this.heartedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'userDisplayName': userDisplayName,
    'userPhotoURL': userPhotoURL,
    'heartedAt': heartedAt,
  };

  static HeartReaction fromJson(Map<String, dynamic> json) => HeartReaction(
    id: json['id'] ?? '',
    postId: json['postId'] ?? '',
    userId: json['userId'] ?? '',
    userDisplayName: json['userDisplayName'] ?? 'User',
    userPhotoURL: json['userPhotoURL'],
    heartedAt: json['heartedAt'] ?? Timestamp.now(),
  );
}
