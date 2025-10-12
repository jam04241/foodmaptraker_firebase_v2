// firebase_collection_initializer.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCollectionInitializer {
  static Future<void> initializeAllCollections() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    print('🚀 Initializing Firebase Collections...');

    try {
      // Initialize collections in order (due to relationships)
      await _initializeUsersCollection(firestore);
      await _initializePostsCollection(firestore);
      await _initializeCommentsCollection(firestore);
      await _initializeHeartReactionsCollection(firestore);
      await _initializeNotificationsCollection(firestore); // ADD THIS LINE

      print('✅ All Firebase collections initialized successfully!');
    } catch (e) {
      print('❌ Error initializing collections: $e');
      rethrow;
    }
  }

  // ==================== USERS COLLECTION ====================
  static Future<void> _initializeUsersCollection(
    FirebaseFirestore firestore,
  ) async {
    final snapshot = await firestore.collection('users').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('👤 Users collection already exists.');
      return;
    }

    print('📝 Creating users collection...');

    final sampleUsers = [
      {
        'uid': 'user_001',
        'email': 'john.doe@example.com',
        'userName': 'John Doe',
        'photoURL': 'https://example.com/avatars/john.jpg',
        'createdAt': Timestamp.now(),
        'lastLogin': Timestamp.now(),
        'emailVerified': true,
        'accountType': 'regular',
      },
      {
        'uid': 'user_002',
        'email': 'jane.smith@example.com',
        'userName': 'Jane Smith',
        'photoURL': 'https://example.com/avatars/jane.jpg',
        'createdAt': Timestamp.now(),
        'lastLogin': Timestamp.now(),
        'emailVerified': true,
        'accountType': 'regular',
      },
      {
        'uid': 'user_003',
        'email': 'mike.johnson@example.com',
        'userName': 'Mike Johnson',
        'photoURL': null,
        'createdAt': Timestamp.now(),
        'lastLogin': Timestamp.now(),
        'emailVerified': false,
        'accountType': 'regular',
      },
    ];

    for (var userData in sampleUsers) {
      final String uid = userData['uid'] as String;
      await firestore.collection('users').doc(uid).set(userData);
    }

    print('✅ Created users collection with ${sampleUsers.length} sample users');
  }

  // ==================== POSTS COLLECTION ====================
  static Future<void> _initializePostsCollection(
    FirebaseFirestore firestore,
  ) async {
    final snapshot = await firestore.collection('posts').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('📝 Posts collection already exists.');
      return;
    }

    print('📝 Creating posts collection...');

    final samplePosts = [
      {
        'id': 'post_001',
        'description':
            'Amazing barbecue experience at Lala\'s! The meat was perfectly cooked and the service was exceptional. Definitely coming back! 🍖',
        'location': 'Obrero, Davao City',
        'rates': '4.5',
        'images': 'images/food2.jpg',
        'userName': 'John Doe', // Denormalized for easy access
        'restaurantName': 'Lala\'s Barbecue',
        'timestamp': Timestamp.now(),
        'isLiked': false,
        'hearts': 15,
        'likedBy': ['user_002', 'user_003'],
        'commentCount': 3,
      },
      {
        'id': 'post_002',
        'description':
            'Cozy coffee shop with the best latte art I\'ve ever seen! Perfect place to work or relax. ☕',
        'location': 'Obrero, Davao City',
        'rates': '4.2',
        'images': 'images/food3.jpg',
        'userName': 'Jane Smith', // Denormalized for easy access
        'restaurantName': 'Slate Coffee + Deli',
        'timestamp': Timestamp.now(),
        'isLiked': true,
        'hearts': 8,
        'likedBy': ['user_001'],
        'commentCount': 2,
      },
      {
        'id': 'post_003',
        'description':
            'Authentic Japanese cuisine that transports you to Tokyo! The sushi was fresh and the ramen was incredible. 🍣',
        'location': 'Obrero, Davao City',
        'rates': '4.8',
        'images': 'images/food4.jpg',
        'userId': 'user_003', // Links to Mike Johnson
        'userName': 'Mike Johnson', // Denormalized for easy access
        'restaurantName': '呑ん気 Nonki Japanese Restaurant',
        'timestamp': Timestamp.now(),
        'isLiked': false,
        'hearts': 23,
        'likedBy': ['user_001', 'user_002'],
        'commentCount': 5,
      },
    ];

    for (var postData in samplePosts) {
      final String postId = postData['id'] as String;
      await firestore.collection('posts').doc(postId).set(postData);
    }

    print('✅ Created posts collection with ${samplePosts.length} sample posts');
  }

  // ==================== COMMENTS COLLECTION ====================
  static Future<void> _initializeCommentsCollection(
    FirebaseFirestore firestore,
  ) async {
    final snapshot = await firestore.collection('comments').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('💬 Comments collection already exists.');
      return;
    }

    print('📝 Creating comments collection...');

    final sampleComments = [
      // Comments for post_001 (Lala's Barbecue)
      {
        'id': 'comment_001',
        'postId': 'post_001',
        'userId': 'user_002',
        'userName': 'Jane Smith',
        'userPhotoURL': 'https://example.com/avatars/jane.jpg',
        'comment': 'I totally agree! Their ribs are the best in town!',
        'rating': 5.0,
        'timestamp': Timestamp.now(),
      },
      {
        'id': 'comment_002',
        'postId': 'post_001',
        'userId': 'user_003',
        'userName': 'Mike Johnson',
        'userPhotoURL': null,
        'comment': 'How were the prices? Worth the money?',
        'rating': 4.0,
        'timestamp': Timestamp.now(),
      },
      {
        'id': 'comment_003',
        'postId': 'post_001',
        'userId': 'user_001',
        'userName': 'John Doe',
        'userPhotoURL': 'https://example.com/avatars/john.jpg',
        'comment': 'Very reasonable! About ₱300 per person for a full meal.',
        'rating': 4.5,
        'timestamp': Timestamp.now(),
      },

      // Comments for post_002 (Slate Coffee)
      {
        'id': 'comment_004',
        'postId': 'post_002',
        'userId': 'user_001',
        'userName': 'John Doe',
        'userPhotoURL': 'https://example.com/avatars/john.jpg',
        'comment': 'Their cold brew is amazing too!',
        'rating': 4.5,
        'timestamp': Timestamp.now(),
      },
      {
        'id': 'comment_005',
        'postId': 'post_002',
        'userId': 'user_003',
        'userName': 'Mike Johnson',
        'userPhotoURL': null,
        'comment': 'Do they have good WiFi for working?',
        'rating': 4.0,
        'timestamp': Timestamp.now(),
      },

      // Comments for post_003 (Nonki Japanese)
      {
        'id': 'comment_006',
        'postId': 'post_003',
        'userId': 'user_001',
        'userName': 'John Doe',
        'userPhotoURL': 'https://example.com/avatars/john.jpg',
        'comment': 'The tempura was perfectly crispy!',
        'rating': 5.0,
        'timestamp': Timestamp.now(),
      },
      {
        'id': 'comment_007',
        'postId': 'post_003',
        'userId': 'user_002',
        'userName': 'Jane Smith',
        'userPhotoURL': 'https://example.com/avatars/jane.jpg',
        'comment': 'Love their sushi platter! So fresh!',
        'rating': 4.5,
        'timestamp': Timestamp.now(),
      },
    ];

    for (var commentData in sampleComments) {
      final String commentId = commentData['id'] as String;
      await firestore.collection('comments').doc(commentId).set(commentData);
    }

    print(
      '✅ Created comments collection with ${sampleComments.length} sample comments',
    );
  }

  // ==================== NOTIFICATIONS COLLECTION ====================
  static Future<void> _initializeNotificationsCollection(
    FirebaseFirestore firestore,
  ) async {
    final snapshot = await firestore.collection('notifications').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('🔔 Notifications collection already exists.');
      return;
    }

    print('📝 Creating notifications collection with sample data...');

    // Sample notifications data
    final sampleNotifications = [
      {
        'numseq': 1,
        'createAt': Timestamp.now(),
        'username': 'John Doe',
        'message': 'Jane Smith react the review on John Doe',
      },
      {
        'numseq': 2,
        'createAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 1)),
        ),
        'username': 'Jane Smith',
        'message': 'Mike Johnson comment on Jane Smith\'s post',
      },
      {
        'numseq': 3,
        'createAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 2)),
        ),
        'username': 'Mike Johnson',
        'message': 'Added a new post',
      },
      {
        'numseq': 4,
        'createAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 3)),
        ),
        'username': 'John Doe',
        'message': 'Jane Smith react the review on Mike Johnson',
      },
      {
        'numseq': 5,
        'createAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 4)),
        ),
        'username': 'Jane Smith',
        'message': 'Added a new post',
      },
    ];

    // Add sample notifications
    for (var notificationData in sampleNotifications) {
      await firestore.collection('notifications').add(notificationData);
    }

    print(
      '✅ Created notifications collection with ${sampleNotifications.length} sample notifications',
    );
  }

  // ==================== HEART REACTIONS COLLECTION ====================
  static Future<void> _initializeHeartReactionsCollection(
    FirebaseFirestore firestore,
  ) async {
    final snapshot = await firestore
        .collection('heartReactions')
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      print('❤️ Heart reactions collection already exists.');
      return;
    }

    print('📝 Creating heart reactions collection...');

    final sampleHearts = [
      // Hearts for post_001
      {
        'id': 'heart_001',
        'postId': 'post_001',
        'userId': 'user_002',
        'userName': 'Jane Smith',
        'userPhotoURL': 'https://example.com/avatars/jane.jpg',
        'heartedAt': Timestamp.now(),
      },
      {
        'id': 'heart_002',
        'postId': 'post_001',
        'userId': 'user_003',
        'userName': 'Mike Johnson',
        'userPhotoURL': null,
        'heartedAt': Timestamp.now(),
      },

      // Hearts for post_002
      {
        'id': 'heart_003',
        'postId': 'post_002',
        'userId': 'user_001',
        'userName': 'John Doe',
        'userPhotoURL': 'https://example.com/avatars/john.jpg',
        'heartedAt': Timestamp.now(),
      },

      // Hearts for post_003
      {
        'id': 'heart_004',
        'postId': 'post_003',
        'userId': 'user_001',
        'userName': 'John Doe',
        'userPhotoURL': 'https://example.com/avatars/john.jpg',
        'heartedAt': Timestamp.now(),
      },
      {
        'id': 'heart_005',
        'postId': 'post_003',
        'userId': 'user_002',
        'userName': 'Jane Smith',
        'userPhotoURL': 'https://example.com/avatars/jane.jpg',
        'heartedAt': Timestamp.now(),
      },
    ];

    for (var heartData in sampleHearts) {
      final String heartId = heartData['id'] as String;
      await firestore.collection('heartReactions').doc(heartId).set(heartData);
    }

    print(
      '✅ Created heart reactions collection with ${sampleHearts.length} sample reactions',
    );
  }

  // ==================== FOUNDATIONAL FUNCTIONS ====================

  // Save new user (for registration)
  static Future<void> saveUserToFirestore(User user, String userName) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      if (user.uid.isEmpty) {
        throw Exception('User UID is empty');
      }

      // Generate a simple userID (you might want a more robust solution)
      final int userID = DateTime.now().millisecondsSinceEpoch;

      final userData = {
        'uid': user.uid,
        'email': user.email ?? '',
        'userID': userID,
        'userName': userName.isNotEmpty ? userName : 'User',
        'photoURL': user.photoURL,
        'createdAt': Timestamp.now(),
        'lastLogin': Timestamp.now(),
        'emailVerified': user.emailVerified,
        'accountType': 'regular',
      };

      await firestore.collection('users').doc(user.uid).set(userData);
      print('✅ User saved to Firestore: ${user.email}');
    } catch (e) {
      print('❌ Error saving user to Firestore: $e');
      rethrow;
    }
  }

  // Create new post
  static Future<void> createPost({
    required String userId,
    required String userName,
    required String description,
    required String location,
    required String restaurantName,
    required String imagePath,
    double rating = 0.0,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final String postId = 'post_${DateTime.now().millisecondsSinceEpoch}';

      final postData = {
        'id': postId,
        'description': description,
        'location': location,
        'rates': rating.toString(),
        'images': imagePath,
        'userId': userId,
        'userName': userName, // Denormalized for performance
        'restaurantName': restaurantName,
        'timestamp': Timestamp.now(),
        'isLiked': false,
        'hearts': 0,
        'likedBy': [],
        'commentCount': 0,
      };

      await firestore.collection('posts').doc(postId).set(postData);
      print('✅ Post created successfully: $postId');
    } catch (e) {
      print('❌ Error creating post: $e');
      rethrow;
    }
  }

  // Add comment to post
  static Future<void> addComment({
    required String postId,
    required String userId,
    required String userName,
    required String comment,
    double rating = 0.0,
    String? userPhotoURL,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final String commentId =
          'comment_${DateTime.now().millisecondsSinceEpoch}';

      final commentData = {
        'id': commentId,
        'postId': postId,
        'userId': userId,
        'userName': userName,
        'userPhotoURL': userPhotoURL,
        'comment': comment,
        'rating': rating,
        'timestamp': Timestamp.now(),
      };

      await firestore.collection('comments').doc(commentId).set(commentData);

      // Update comment count in post
      await firestore.collection('posts').doc(postId).update({
        'commentCount': FieldValue.increment(1),
      });

      print('✅ Comment added successfully: $commentId');
    } catch (e) {
      print('❌ Error adding comment: $e');
      rethrow;
    }
  }

  // Add/Remove heart reaction
  static Future<void> toggleHeartReaction({
    required String postId,
    required String userId,
    required String userName,
    String? userPhotoURL,
    required bool isLiking,
    required String postOwnerUsername,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final String heartId = 'heart_${postId}_$userId';

      if (isLiking) {
        // Add heart reaction
        final heartData = {
          'id': heartId,
          'postId': postId,
          'userId': userId,
          'userName': userName,
          'userPhotoURL': userPhotoURL,
          'heartedAt': Timestamp.now(),
        };

        await firestore
            .collection('heartReactions')
            .doc(heartId)
            .set(heartData);

        // Update post heart count and likedBy array
        await firestore.collection('posts').doc(postId).update({
          'hearts': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([userId]),
        });

        print('✅ Heart added to post: $postId');
      } else {
        // Remove heart reaction
        await firestore.collection('heartReactions').doc(heartId).delete();

        // Update post heart count and likedBy array
        await firestore.collection('posts').doc(postId).update({
          'hearts': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([userId]),
        });

        print('✅ Heart removed from post: $postId');
      }
    } catch (e) {
      print('❌ Error toggling heart reaction: $e');
      rethrow;
    }
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      if (uid.isEmpty) {
        print('⚠️ Cannot get user data: UID is empty');
        return null;
      }

      final doc = await firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }
}
