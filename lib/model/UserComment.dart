import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userDisplayName;
  final String userPhotoURL;
  final String comment;
  final double rating;
  final Timestamp timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userDisplayName,
    required this.userPhotoURL,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'userDisplayName': userDisplayName,
    'userPhotoURL': userPhotoURL,
    'comment': comment,
    'rating': rating,
    'timestamp': timestamp,
  };

  static Comment fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'] ?? '',
    postId: json['postId'] ?? '',
    userId: json['userId'] ?? '',
    userDisplayName: json['userDisplayName'] ?? 'Anonymous',
    userPhotoURL: json['userPhotoURL'] ?? '',
    comment: json['comment'] ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    timestamp: json['timestamp'] ?? Timestamp.now(),
  );
}
