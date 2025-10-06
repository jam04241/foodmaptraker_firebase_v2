import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodtracker_firebase/model/postUser.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // Get posts that current user has liked - with local sorting
  Stream<List<PostUser>> _getLikedPosts() {
    if (_currentUser == null) {
      return Stream.value([]);
    }

    try {
      return _firestore
          .collection('posts')
          .where('likedBy', arrayContains: _currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            final posts = snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return PostUser.fromJson(data);
            }).toList();
            return posts;
          })
          .handleError((error) {
            print('Firestore query error: $error');
            // Return empty list on error, or implement fallback
            return [];
          });
    } catch (e) {
      print('Error setting up stream: $e');
      return Stream.value([]);
    }
  }

  // Toggle like status
  Future<void> toggleLike(PostUser post) async {
    try {
      if (_currentUser == null) return;

      final isCurrentlyLiked = post.likedBy.contains(_currentUser!.uid);

      await _firestore.collection('posts').doc(post.id).update({
        'isLiked': !isCurrentlyLiked,
        'hearts': isCurrentlyLiked ? (post.hearts - 1) : (post.hearts + 1),
        'likedBy': isCurrentlyLiked
            ? FieldValue.arrayRemove([_currentUser!.uid])
            : FieldValue.arrayUnion([_currentUser!.uid]),
      });
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  // Get time ago from timestamp
  String getTimeAgo(dynamic timestamp) {
    if (timestamp == null) return "Recently";

    DateTime postTime;

    // Handle both Timestamp and DateTime
    if (timestamp is Timestamp) {
      postTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      postTime = timestamp;
    } else {
      return "Recently";
    }

    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }

  Widget trendingCard(PostUser post) {
    // Convert rates string to double for rating
    double rating = double.tryParse(post.rates) ?? 0.0;

    // Parse images - assuming it's a single URL string, convert to list
    List<String> restaurantImages = post.images.isNotEmpty ? [post.images] : [];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff2f4a5d), // ✅ Same dark blue background
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info + Heart
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    post.location,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Text(
                    post.restaurantName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    getTimeAgo(post.timestamp),
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () => toggleLike(post),
                child: Row(
                  children: [
                    Icon(
                      post.likedBy.contains(_currentUser?.uid ?? '')
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 20,
                      color: post.likedBy.contains(_currentUser?.uid ?? '')
                          ? Colors.red
                          : Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${post.hearts ?? 0}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rating
          Row(
            children: [
              RatingBarIndicator(
                rating: rating,
                itemBuilder: (context, index) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 20,
                direction: Axis.horizontal,
              ),
              const SizedBox(width: 8),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Caption
          Text(
            post.description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Restaurant Pictures
          if (restaurantImages.isNotEmpty)
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: restaurantImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, imgIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: restaurantImages[imgIndex],
                      width: 220,
                      height: 160,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 220,
                        height: 160,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 220,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text(
            'Not Logged In',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please log in to view your favorite posts',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff2f4a5d),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 24, backgroundColor: Colors.grey[300]),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 4),
                      Container(height: 12, width: 80, color: Colors.grey[300]),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 14,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              Container(height: 14, width: 200, color: Colors.grey[300]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_border, size: 60, color: Colors.red),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Posts you like will appear here',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(
                context,
              ); // Go back to trending to find posts to like
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.explore),
            label: const Text('Explore Posts'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff213448),
      appBar: AppBar(
        title: const Text("Favorites", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff213448),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: _currentUser == null
          ? _buildNotLoggedIn()
          : StreamBuilder<List<PostUser>>(
              stream: _getLikedPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final likedPosts = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: likedPosts
                        .map((post) => trendingCard(post))
                        .toList(),
                  ),
                );
              },
            ),
    );
  }
}
