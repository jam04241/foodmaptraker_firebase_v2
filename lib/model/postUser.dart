// PostUser.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PostUser {
  final String id;
  final String description;
  final String location;
  final String rates;
  final String images;
  final String userId;
  final String userName;
  final String restaurantName;
  final Timestamp timestamp;
  final bool isLiked;
  final int hearts;
  final List<String> likedBy;
  final int commentCount;

  PostUser({
    required this.id,
    required this.description,
    required this.location,
    required this.rates,
    required this.images,
    required this.userId,
    required this.userName,
    required this.restaurantName,
    required this.timestamp,
    required this.isLiked,
    required this.hearts,
    required this.likedBy,
    required this.commentCount,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'location': location,
      'rates': rates,
      'images': images,
      'userId': userId,
      'userName': userName,
      'restaurantName': restaurantName,
      'timestamp': timestamp,
      'isLiked': isLiked,
      'hearts': hearts,
      'likedBy': likedBy,
      'commentCount': commentCount,
    };
  }

  // Create from JSON from Firestore
  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      rates: json['rates'] ?? '0.0',
      images: json['images'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'User',
      restaurantName: json['restaurantName'] ?? 'Restaurant',
      timestamp: json['timestamp'] ?? Timestamp.now(),
      isLiked: json['isLiked'] ?? false,
      hearts: (json['hearts'] as num?)?.toInt() ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
    );
  }
}
