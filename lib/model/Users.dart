import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String userName;
  final String? photoURL;
  final Timestamp createdAt;

  User({
    required this.uid,
    required this.email,
    required this.userName,
    this.photoURL,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'userName': userName,
    'photoURL': photoURL,
    'createdAt': createdAt,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    uid: json['uid'] ?? '',
    email: json['email'] ?? '',
    userName: json['userName'] ?? '',
    photoURL: json['photoURL'],
    createdAt: json['createdAt'] ?? Timestamp.now(),
  );
}
