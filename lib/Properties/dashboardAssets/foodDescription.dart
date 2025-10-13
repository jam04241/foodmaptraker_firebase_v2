import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodtracker_firebase/services/recommendation_service.dart';
import 'package:foodtracker_firebase/model/postUser.dart';
import 'package:foodtracker_firebase/model/UserComment.dart';

class Fooddescription extends StatefulWidget {
  final PostUser post;

  const Fooddescription({super.key, required this.post});

  @override
  State<Fooddescription> createState() => _FooddescriptionState();
}

class _FooddescriptionState extends State<Fooddescription> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool get isRecommended =>
      RecommendationService.isPostRecommended(widget.post);
  bool _isIndexCreating = false;

  // Stream to fetch comments for this post with error handling
  Stream<List<Comment>> getCommentsForPost() {
    return _firestore
        .collection('comments')
        .where('postId', isEqualTo: widget.post.id)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .handleError((error) {
          print('Firestore comments error: $error');
          // Return an empty list on error to prevent stream breaking
          return Stream.value([]);
        })
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              return Comment(
                id: doc.id,
                postId: data['postId'] ?? '',
                userId: data['userId'] ?? '',
                userName: data['userName'] ?? 'User',
                userPhotoURL: data['userPhotoURL'],
                comment: data['comment'] ?? '',
                rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
                timestamp: data['timestamp'] ?? Timestamp.now(),
              );
            } catch (e) {
              print('Error parsing comment: $e');
              return Comment(
                id: doc.id,
                postId: '',
                userId: '',
                userName: 'User',
                userPhotoURL: '',
                comment: 'Error loading comment',
                rating: 0.0,
                timestamp: Timestamp.now(),
              );
            }
          }).toList(),
        );
  }

  // Alternative method without ordering to avoid index requirement
  Stream<List<Comment>> getCommentsWithoutOrder() {
    return _firestore
        .collection('comments')
        .where('postId', isEqualTo: widget.post.id)
        .snapshots()
        .handleError((error) {
          print('Firestore comments error: $error');
          return Stream.value([]);
        })
        .map((snapshot) {
          final comments = snapshot.docs.map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              return Comment(
                id: doc.id,
                postId: data['postId'] ?? '',
                userId: data['userId'] ?? '',
                userName: data['userName'] ?? 'User',
                userPhotoURL: data['userPhotoURL'],
                comment: data['comment'] ?? '',
                rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
                timestamp: data['timestamp'] ?? Timestamp.now(),
              );
            } catch (e) {
              print('Error parsing comment: $e');
              return Comment(
                id: doc.id,
                postId: '',
                userId: '',
                userName: 'User',
                userPhotoURL: '',
                comment: 'Error loading comment',
                rating: 0.0,
                timestamp: Timestamp.now(),
              );
            }
          }).toList();

          // Sort manually by timestamp if we have data
          comments.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return comments;
        });
  }

  void _createIndex() {
    setState(() {
      _isIndexCreating = true;
    });

    // This is just a visual indicator - the actual index needs to be created in Firebase Console
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isIndexCreating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please create the index in Firebase Console using the provided link',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Back Arrow Overlay
            Stack(
              children: [
                post.images.isNotEmpty
                    ? Image.network(
                        post.images,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      )
                    : _buildPlaceholderImage(),
                Positioned(
                  top: 15,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                if (isRecommended)
                  Positioned(
                    top: 15,
                    right: 16,
                    child: _buildRecommendationBadge(),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Title & Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          post.restaurantName.isNotEmpty
                              ? post.restaurantName
                              : 'Restaurant',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff213448),
                          ),
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        _buildSmallRecommendationBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.location.isNotEmpty
                        ? post.location
                        : 'Location not specified',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                post.description.isNotEmpty
                    ? post.description
                    : 'No description available',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${double.tryParse(post.rates)?.toStringAsFixed(1) ?? '0.0'}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${post.hearts} likes',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        post.userName,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(color: Colors.grey),

            if (isRecommended) _buildRecommendationHighlight(),

            const SizedBox(height: 30),

            // User Comments Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    "User Comments",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff213448),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Comment count badge
                  StreamBuilder<List<Comment>>(
                    stream: getCommentsWithoutOrder(), // Use the safe version
                    builder: (context, snapshot) {
                      final commentCount = snapshot.hasData
                          ? snapshot.data!.length
                          : 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff213448),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$commentCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Comments List
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: _buildCommentsSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return StreamBuilder<List<Comment>>(
      stream:
          getCommentsWithoutOrder(), // Use the safe version without ordering
      builder: (context, snapshot) {
        // Handle different states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCommentsWidget();
        }

        if (snapshot.hasError) {
          return _buildIndexErrorWidget(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoCommentsWidget();
        }

        final comments = snapshot.data!;
        return Column(
          children: comments
              .map((comment) => _buildCommentCard(comment))
              .toList(),
        );
      },
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xffdbe7c9),
            child:
                comment.userPhotoURL != null && comment.userPhotoURL!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      comment.userPhotoURL!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, color: Colors.grey);
                      },
                    ),
                  )
                : const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 12),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name and rating
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xff213448),
                      ),
                    ),
                    const Spacer(),
                    if (comment.rating > 0) ...[
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        comment.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),

                // Comment text
                Text(
                  comment.comment,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),

                // Timestamp
                const SizedBox(height: 6),
                Text(
                  _formatTimestamp(comment.timestamp),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.build_circle_outlined,
            size: 50,
            color: Colors.orange,
          ),
          const SizedBox(height: 10),
          const Text(
            'Index Required',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'To display comments, we need to create a database index.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 12),
          if (_isIndexCreating) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text('Setting up index...'),
          ] else ...[
            ElevatedButton(
              onPressed: _createIndex,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text(
                'Create Index',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Note: This is a one-time setup. The app will work normally afterwards.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCommentsWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey[400]),
          const SizedBox(height: 10),
          const Text(
            'No comments yet',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be the first to share your thoughts about this meal!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCommentsWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            'Loading comments...',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final commentTime = timestamp.toDate();
    final difference = now.difference(commentTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${commentTime.day}/${commentTime.month}/${commentTime.year}';
    }
  }

  Widget _buildRecommendationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, size: 16, color: Colors.black),
          SizedBox(width: 4),
          Text(
            'RECOMMENDED',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallRecommendationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, size: 12, color: Colors.black),
          SizedBox(width: 2),
          Text(
            'REC',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationHighlight() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.amber.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Recommended',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This meal has been highly rated by the community with ${widget.post.hearts} likes!',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 60, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'No Image Available',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
