import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodtracker_firebase/Properties/trendingAssets/post_modal.dart';
import 'package:foodtracker_firebase/Properties/trendingAssets/review_modal.dart';

class NavTrendingPage extends StatefulWidget {
  const NavTrendingPage({super.key});

  @override
  State<NavTrendingPage> createState() => _TrendingsState();
}

class _TrendingsState extends State<NavTrendingPage> {
  final TextEditingController postController = TextEditingController();

  List<Map<String, dynamic>> posts = [
    {
      "username": "Alice",
      "location": "Manila, Philippines",
      "profileImage": "https://randomuser.me/api/portraits/women/44.jpg",
      "restaurant": "Ichiran Ramen",
      "restaurantImages": [
        "https://images.pexels.com/photos/1199957/pexels-photo-1199957.jpeg",
        "https://images.pexels.com/photos/941861/pexels-photo-941861.jpeg",
      ],
      "caption": "Best ramen I’ve had 🍜🔥",
      "rating": 4.7,
      "hearts": 123,
      "isLiked": false,
      "comment": "",
      "timeAgo": "2h ago",
    },
    {
      "username": "Bob",
      "location": "Cebu City",
      "profileImage": "https://randomuser.me/api/portraits/men/36.jpg",
      "restaurant": "Lantaw Native Restaurant",
      "restaurantImages": [
        "https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg",
        "https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg",
      ],
      "caption": "Chill vibes, good food 😋",
      "rating": 4.3,
      "hearts": 98,
      "isLiked": false,
      "comment": "",
      "timeAgo": "5h ago",
    },
    {
      "username": "Carla",
      "location": "Davao City",
      "profileImage": "https://randomuser.me/api/portraits/women/65.jpg",
      "restaurant": "Yellow Fin Seafood",
      "restaurantImages": [
        "https://images.pexels.com/photos/4210859/pexels-photo-4210859.jpeg",
        "https://images.pexels.com/photos/3296273/pexels-photo-3296273.jpeg",
      ],
      "caption": "Fresh seafood, highly recommended 🐟🦐",
      "rating": 4.8,
      "hearts": 210,
      "isLiked": false,
      "comment": "",
      "timeAgo": "1d ago",
    },
    {
      "username": "Daniel",
      "location": "Quezon City",
      "profileImage": "https://randomuser.me/api/portraits/men/22.jpg",
      "restaurant": "Burger Shack",
      "restaurantImages": [
        "https://images.pexels.com/photos/1639567/pexels-photo-1639567.jpeg",
      ],
      "caption": "Burgers were okay, but kinda dry 🍔",
      "rating": 3.5,
      "hearts": 54,
      "isLiked": false,
      "comment": "",
      "timeAgo": "3d ago",
    },
    {
      "username": "Ella",
      "location": "Taguig",
      "profileImage": "https://randomuser.me/api/portraits/women/12.jpg",
      "restaurant": "Sushi Express",
      "restaurantImages": [
        "https://images.pexels.com/photos/357756/pexels-photo-357756.jpeg",
        "https://images.pexels.com/photos/2098085/pexels-photo-2098085.jpeg",
      ],
      "caption": "Too much rice, less fish 🍣😕",
      "rating": 2.8,
      "hearts": 37,
      "isLiked": false,
      "comment": "",
      "timeAgo": "5d ago",
    },
    {
      "username": "Frank",
      "location": "Makati",
      "profileImage": "https://randomuser.me/api/portraits/men/77.jpg",
      "restaurant": "Pizza Town",
      "restaurantImages": [
        "https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg",
      ],
      "caption": "Pizza was cold when served 🍕❄️",
      "rating": 3.2,
      "hearts": 80,
      "isLiked": false,
      "comment": "",
      "timeAgo": "1w ago",
    },
  ];

  String sortOrder = "Highest First";

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  // Sort posts based on rating
  void sortPosts() {
    setState(() {
      if (sortOrder == "Highest First") {
        posts.sort((a, b) => (b["rating"] as double).compareTo(a["rating"]));
      } else {
        posts.sort((a, b) => (a["rating"] as double).compareTo(b["rating"]));
      }
    });
  }

  // Open Post Modal
  void openPostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostModal(postController: postController),
    );
  }

  // Open Review Modal
  void openCommentModal(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewModal(
        restaurantName: posts[index]["restaurant"],
        onSubmit: (rating, comment) {
          setState(() {
            posts[index]["rating"] = rating;
            posts[index]["comment"] = comment;
            posts[index]["hearts"] = (posts[index]["hearts"] as int) + 1;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Review submitted successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  // Post Card
  Widget trendingCard(int index) {
    final post = posts[index];
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                backgroundImage: NetworkImage(post["profileImage"]),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post["username"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    post["location"],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    post["restaurant"],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    post["timeAgo"], // timeline
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    if (post["isLiked"] == true) {
                      post["isLiked"] = false;
                      post["hearts"] = (post["hearts"] as int) - 1;
                    } else {
                      post["isLiked"] = true;
                      post["hearts"] = (post["hearts"] as int) + 1;
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      post["isLiked"] ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: post["isLiked"] ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${post["hearts"]}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                rating: post["rating"],
                itemBuilder: (context, index) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 20,
                direction: Axis.horizontal,
              ),
              const SizedBox(width: 8),
              Text(
                post["rating"].toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Caption
          Text(
            post["caption"],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          // Restaurant Pictures
          if (post["restaurantImages"].isNotEmpty)
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: post["restaurantImages"].length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, imgIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      post["restaurantImages"][imgIndex],
                      width: 220,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 12),

          // Comment input below the pictures
          InkWell(
            onTap: () => openCommentModal(context, index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xfff0f0f0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "What's on your mind?",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
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
    sortPosts();

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
                  sortPosts();
                });
              },
              color: Colors.white,
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: "Highest First",
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_downward, color: Colors.black54),
                      SizedBox(width: 8),
                      Text("Highest First"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Lowest First",
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_upward, color: Colors.black54),
                      SizedBox(width: 8),
                      Text("Lowest First"),
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
                color: Colors.white,
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
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/12.jpg",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfff0f0f0),
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
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Posts
            for (int i = 0; i < posts.length; i++) trendingCard(i),
          ],
        ),
      ),
    );
  }
}
