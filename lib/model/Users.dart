import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final Timestamp createdAt;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoURL': photoURL,
    'createdAt': createdAt,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    uid: json['uid'] ?? '',
    email: json['email'] ?? '',
    displayName: json['displayName'] ?? '',
    photoURL: json['photoURL'],
    createdAt: json['createdAt'] ?? Timestamp.now(),
  );
}

class PostUser {
  final String description;
  final String location;
  final String rates;
  final String images;
  final String id;
  final String userId;
  final String restaurantName;
  final Timestamp? timestamp;
  final bool? isLiked;
  final int? hearts;
  final List<String>? likedBy;

  PostUser({
    required this.description,
    required this.location,
    required this.rates,
    required this.images,
    required this.id,
    required this.userId,
    required this.restaurantName,
    this.timestamp,
    this.isLiked = false,
    this.hearts = 0,
    this.likedBy = const [],
  });

  static PostUser fromJson(Map<String, dynamic> json) => PostUser(
    id: json['id'] ?? '',
    description: json['description'] ?? '',
    location: json['location'] ?? '',
    rates: json['rates'] ?? '0',
    images: json['images'] ?? '',
    userId: json['userId'] ?? 'unknown',
    restaurantName: json['restaurantName'] ?? 'Restaurant',
    timestamp: json['timestamp'],
    isLiked: json['isLiked'] ?? false,
    hearts: json['hearts'] ?? 0,
    likedBy: List<String>.from(json['likedBy'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'location': location,
    'rates': rates,
    'images': images,
    'userId': userId,
    'restaurantName': restaurantName,
    'timestamp': timestamp ?? Timestamp.now(),
    'isLiked': isLiked ?? false,
    'hearts': hearts ?? 0,
    'likedBy': likedBy ?? [],
  };
}
