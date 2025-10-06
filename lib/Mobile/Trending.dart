import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodtracker_firebase/Properties/trendingAssets/post_modal.dart';
import 'package:foodtracker_firebase/Properties/trendingAssets/review_modal.dart';
import 'package:foodtracker_firebase/model/Users.dart';
import 'package:foodtracker_firebase/model/postUser.dart';

class NavTrendingPage extends StatefulWidget {
  const NavTrendingPage({super.key});

  @override
  State<NavTrendingPage> createState() => _TrendingsState();
}

class _TrendingsState extends State<NavTrendingPage> {
  final TextEditingController postController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? currentUserId;
  String? currentUserName;
  String sortOrder = "Newest Post"; // ✅ CHANGED DEFAULT TO NEWEST POST

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            currentUserId = user.uid;
            currentUserName = userDoc.data()?['userName'] ?? 'User';
          });
        }
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
  }

  // Open Post Modal
  void openPostModal(BuildContext context) {
    // Check if user data is available
    if (currentUserId == null || currentUserName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to create a post'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostModal(
        postController: postController,
        currentUserId: currentUserId!, // ✅ PASS USER ID
        currentUserName: currentUserName!, // ✅ PASS USERNAME
      ),
    ).then((_) {
      setState(() {});
    });
  }

  // Open Review Modal
  void openCommentModal(BuildContext context, PostUser post) {
    Widget buildReviewModal(BuildContext context) {
      return ReviewModal(
        postId: post.id,
        restaurantName: "Restaurant",
        onSubmit: (double rating, String comment) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Review submitted successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        },
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: buildReviewModal, // Use the separate builder function
    ).then((value) {
      setState(() {});
    });
  }

  // Toggle like status
  Future<void> toggleLike(PostUser post) async {
    try {
      // ✅ USE ACTUAL CURRENT USER ID
      if (currentUserId == null) return;

      final isCurrentlyLiked = post.likedBy.contains(currentUserId);

      await _firestore.collection('posts').doc(post.id).update({
        'isLiked': !isCurrentlyLiked,
        'hearts': isCurrentlyLiked ? (post.hearts - 1) : (post.hearts + 1),
        'likedBy': isCurrentlyLiked
            ? FieldValue.arrayRemove([currentUserId])
            : FieldValue.arrayUnion([currentUserId]),
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

  // Post Card
  Widget trendingCard(PostUser post) {
    // Convert rates string to double for rating
    double rating = double.tryParse(post.rates) ?? 0.0;

    // Parse images - assuming it's a single URL string, convert to list
    List<String> restaurantImages = post.images.isNotEmpty ? [post.images] : [];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff2f4a5d), // ✅ BACKGROUND COLOR CHANGED
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User section
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
                      color: Colors.white, // ✅ Text color for better contrast
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
                      color: Colors.white, // ✅ Text color for better contrast
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
                      (post.isLiked ?? false)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 20,
                      color: (post.isLiked ?? false)
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
                  color: Colors.white, // ✅ Text color for better contrast
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
              color: Colors.white, // ✅ Text color for better contrast
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
                    child: Image.network(
                      restaurantImages[imgIndex],
                      width: 220,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 220,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 12),

          // Comment input below the pictures
          InkWell(
            onTap: () => openCommentModal(context, post),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff3a556e), // ✅ Slightly lighter background
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "What's on your mind?",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70, // ✅ Lighter text color
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
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
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: const Color(0xff213448),
        title: const Text(
          "Trending",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PopupMenuButton<String>(
              onSelected: (String newValue) {
                setState(() {
                  sortOrder = newValue;
                });
              },
              color: Colors.white,
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (BuildContext context) => [
                // ✅ CHANGED TO NEWEST POST
                PopupMenuItem(
                  value: "Newest Post",
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_downward, color: Colors.black54),
                      SizedBox(width: 8),
                      Text("Newest Post"),
                    ],
                  ),
                ),
                // ✅ CHANGED TO OLDEST POST
                PopupMenuItem(
                  value: "Oldest Post",
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_upward, color: Colors.black54),
                      SizedBox(width: 8),
                      Text("Oldest Post"),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sort, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      sortOrder,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            // Create Post Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff2f4a5d),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(radius: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3a556e),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => openPostModal(context),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "What's on your mind?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Posts from Firebase
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('posts')
                  .orderBy(
                    'timestamp',
                    descending: true,
                  ) // Default: newest first
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.post_add, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'No posts yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Be the first to share your food experience!',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Convert documents to PostUser objects
                List<PostUser> posts = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return PostUser.fromJson(data);
                }).toList();

                // ✅ UPDATED SORTING LOGIC FOR TIMESTAMP
                if (sortOrder == "Newest Post") {
                  // Already sorted by newest first from Firestore, no need to re-sort
                  // Or reverse if needed
                  posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                } else if (sortOrder == "Oldest Post") {
                  posts.sort((a, b) => a.timestamp.compareTo(b.timestamp));
                }

                return Column(
                  children: posts.map((post) => trendingCard(post)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
