import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final User? _currentUser = FirebaseAuth.instance.currentUser;

  static Future<bool> toggleLike({
    required String postId,
    required bool currentLikeStatus,
    required List<String> currentLikedBy,
  }) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      final currentUserId = _currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('User not logged in');
      }

      final newLikedBy = List<String>.from(currentLikedBy);

      if (currentLikeStatus) {
        newLikedBy.remove(currentUserId);
      } else {
        if (!newLikedBy.contains(currentUserId)) {
          newLikedBy.add(currentUserId);
        }
      }

      final newHearts = newLikedBy.length;

      await postRef.update({'hearts': newHearts, 'likedBy': newLikedBy});

      return true;
    } catch (e) {
      print('❌ LikeService Error: $e');
      return false;
    }
  }

  static bool isPostLikedByUser(List<String> likedBy, String? userId) {
    if (userId == null) return false;
    return likedBy.contains(userId);
  }
}
