import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onCommentTap;
  final VoidCallback onHeartTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onCommentTap,
    required this.onHeartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff2f4a5d),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(post.profileImage),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    post.location,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    post.restaurant,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    post.timeAgo,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),

              // ❤️ Heart button
              InkWell(
                onTap: onHeartTap,
                child: Row(
                  children: [
                    const Icon(Icons.favorite, size: 20, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      "${post.hearts}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Post Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(post.imageUrl, fit: BoxFit.cover),
          ),

          const SizedBox(height: 8),

          // Rating
          Row(
            children: [
              RatingBarIndicator(
                rating: post.rating,
                itemBuilder: (context, index) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemSize: 18,
              ),
              const SizedBox(width: 6),
              Text(
                post.rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Review Text
          Text(post.review),

          const SizedBox(height: 8),

          // "What's on your mind" below picture
          InkWell(
            onTap: onCommentTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "What's on your mind?",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
