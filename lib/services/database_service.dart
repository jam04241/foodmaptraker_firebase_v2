import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodtracker_firebase/model/UserComment.dart';
import 'package:foodtracker_firebase/model/Users.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users Collection
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts');
  final CollectionReference commentsCollection = FirebaseFirestore.instance
      .collection('comments');

  // User Operations
  Future<void> saveUser(User user) async {
    try {
      await usersCollection.doc(user.uid).set(user.toJson());
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  Future<User?> getUser(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Post Operations
  Future<void> savePost(PostUser post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      print('Error saving post: $e');
      rethrow;
    }
  }

  Future<void> updatePostLikes(
    String postId,
    String userId,
    bool isLiked,
  ) async {
    try {
      final postRef = postsCollection.doc(postId);

      if (isLiked) {
        // Add like
        await postRef.update({
          'hearts': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([userId]),
        });
      } else {
        // Remove like
        await postRef.update({
          'hearts': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([userId]),
        });
      }
    } catch (e) {
      print('Error updating post likes: $e');
      rethrow;
    }
  }

  // Comment Operations
  Future<String> addComment(Comment comment) async {
    try {
      final commentRef = commentsCollection.doc();
      final commentId = commentRef.id;

      final commentWithId = Comment(
        id: commentId,
        postId: comment.postId,
        userId: comment.userId,
        userDisplayName: comment.userDisplayName,
        userPhotoURL: comment.userPhotoURL,
        comment: comment.comment,
        rating: comment.rating,
        timestamp: comment.timestamp,
      );

      await commentRef.set(commentWithId.toJson());
      return commentId;
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getCommentsForPost(String postId) {
    return commentsCollection
        .where('postId', isEqualTo: postId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // FIXED: Get posts by user ID - using _firestore instead of firestore
  Stream<List<PostUser>> getPostsByUserId(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PostUser.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  // FIXED: Get all posts - using _firestore instead of firestore
  Stream<List<PostUser>> getAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PostUser.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  Future<void> updateComment(
    String commentId,
    String newComment,
    double newRating,
  ) async {
    try {
      await commentsCollection.doc(commentId).update({
        'comment': newComment,
        'rating': newRating,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating comment: $e');
      rethrow;
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await commentsCollection.doc(commentId).delete();
    } catch (e) {
      print('Error deleting comment: $e');
      rethrow;
    }
  }

  // Get user's comments
  Stream<QuerySnapshot> getUserComments(String userId) {
    return commentsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get average rating for a post
  Future<double> getPostAverageRating(String postId) async {
    try {
      final snapshot = await commentsCollection
          .where('postId', isEqualTo: postId)
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      double totalRating = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalRating += (data['rating'] as num).toDouble();
      }

      return totalRating / snapshot.docs.length;
    } catch (e) {
      print('Error calculating average rating: $e');
      return 0.0;
    }
  }

  // Check if user has commented on a post
  Future<bool> hasUserCommented(String postId, String userId) async {
    try {
      final snapshot = await commentsCollection
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user comment: $e');
      return false;
    }
  }
}
