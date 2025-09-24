import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Properties/trendingAssets/post_modal.dart';
import 'package:foodtracker_firebase/Properties/trendingAssets/review_modal.dart';
import 'package:foodtracker_firebase/Properties/trendingAssets/trending_card.dart';

class NavTrendingPage extends StatefulWidget {
  const NavTrendingPage({super.key});

  @override
  State<NavTrendingPage> createState() => _TrendingsState();
}

class _TrendingsState extends State<NavTrendingPage> {
  final TextEditingController postController = TextEditingController();

  final List<Map<String, dynamic>> posts = [
    {
      "username": "Stifin Tatel",
      "location": "Obrero, Davao City, Philippines",
      "profileImage": "images/post6.jpg",
      "restaurant": "Stifin",
      "restaurantImages": [
        "images/coffee1.jpg",
        "images/coffee2.jpg",
        "images/coffee3.jpg",
      ],
      "caption": "Best Coffee Cafe Ever🔥",
      "rating": 4.7,
      "views": 123,
      "comment": "",
    },
    {
      "username": "Mommy Jupeta",
      "location": "Obrero, Davao City, Philippines",
      "profileImage": "images/post6.jpg",
      "restaurant": "Yummy Stephen Tatel",
      "restaurantImages": ["images/food1.jpg", "images/food2.jpg"],
      "caption": "Chill vibes, good food 😋",
      "rating": 4.3,
      "views": 98,
      "comment": "",
    },
    {
      "username": "JohnLloyd Girozaga",
      "location": "Davao City",
      "profileImage": "images/food1.jpg",
      "restaurant": "Yellow Fin Seafood",
      "restaurantImages": [
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
        "https://images.unsplash.com/photo-1543351611-58f69d8c8c2d",
      ],
      "caption": "Fresh seafood, highly recommended 🐟🦐",
      "rating": 4.8,
      "views": 210,
      "comment": "",
    },
  ];

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
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
            posts[index]["views"] = (posts[index]["views"] as int) + 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff213448),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: const Color(0xff213448),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Text(
            "Trending",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
                boxShadow: [
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
                              fontFamily: 'Montserrat',
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
            for (int i = 0; i < posts.length; i++)
              TrendingCard(
                post: posts[i],
                onTapComment: () => openCommentModal(context, i),
              ),
          ],
        ),
      ),
    );
  }
}
