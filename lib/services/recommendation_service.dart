import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodtracker_firebase/model/postUser.dart';

class RecommendationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get recommended posts (20+ likes, limited to 5)
  static Stream<List<PostUser>> getRecommendedPosts() {
    return _firestore
        .collection('posts')
        .where('hearts', isGreaterThanOrEqualTo: 20)
        .orderBy('hearts', descending: true)
        .limit(5)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return PostUser.fromJson(data);
          }).toList(),
        );
  }

  // Get recommended posts as Future (for one-time loading)
  static Future<List<PostUser>> getRecommendedPostsOnce() async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('hearts', isGreaterThanOrEqualTo: 20)
          .orderBy('hearts', descending: true)
          .limit(5)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PostUser.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting recommended posts: $e');
      return [];
    }
  }

  // Check if a post is recommended (has 20+ likes)
  static bool isPostRecommended(PostUser post) {
    return post.hearts >= 20;
  }

  // Get trending posts (could be used in trending page)
  static Stream<List<PostUser>> getTrendingPosts({int limit = 10}) {
    return _firestore
        .collection('posts')
        .where(
          'hearts',
          isGreaterThanOrEqualTo: 10,
        ) // Lower threshold for trending
        .orderBy('hearts', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return PostUser.fromJson(data);
          }).toList(),
        );
  }

  // Get popular posts for different sections
  static Stream<List<PostUser>> getPopularPosts({
    int minLikes = 15,
    int limit = 3,
  }) {
    return _firestore
        .collection('posts')
        .where('hearts', isGreaterThanOrEqualTo: minLikes)
        .orderBy('hearts', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return PostUser.fromJson(data);
          }).toList(),
        );
  }
}
