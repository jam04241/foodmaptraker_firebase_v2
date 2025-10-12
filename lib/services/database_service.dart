import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodtracker_firebase/model/UserComment.dart';
import 'package:foodtracker_firebase/model/Users.dart';
import 'package:foodtracker_firebase/model/postUser.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts');
  final CollectionReference commentsCollection = FirebaseFirestore.instance
      .collection('comments');
  final CollectionReference heartReactionsCollection = FirebaseFirestore
      .instance
      .collection('heartReactions');
  final CollectionReference notificationsCollection = FirebaseFirestore.instance
      .collection('notifications');

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
        await postRef.update({
          'hearts': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([userId]),
        });
      } else {
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

  // ==================== NOTIFICATION FUNCTIONS ====================

  // ✅ FIXED: Make these instance methods, not static
  Future<void> addNotification({
    required String username,
    required String message,
  }) async {
    try {
      // Get the next numseq by counting existing notifications
      final notificationsCount = await notificationsCollection.count().get();

      final int numseq = notificationsCount.count! + 1;

      final notificationData = {
        'numseq': numseq,
        'createAt': Timestamp.now(),
        'username': username,
        'message': message,
      };

      await notificationsCollection.add(notificationData);
      print('✅ Notification added: $message');
    } catch (e) {
      print('❌ Error adding notification: $e');
      rethrow;
    }
  }

  // ✅ FIXED: Make these instance methods
  Future<void> createReactionNotification({
    required String reactingUsername,
    required String postOwnerUsername,
  }) async {
    final message = '$reactingUsername react the review on $postOwnerUsername';
    await addNotification(username: reactingUsername, message: message);
  }

  Future<void> createCommentNotification({
    required String commentingUsername,
    required String postOwnerUsername,
  }) async {
    final message = '$commentingUsername comment on $postOwnerUsername\'s post';
    await addNotification(username: commentingUsername, message: message);
  }

  Future<void> createPostNotification({required String username}) async {
    final message = 'Added a new post';
    await addNotification(username: username, message: message);
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
        userName: comment.userName,
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
