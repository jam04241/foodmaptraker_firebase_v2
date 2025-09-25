class PostModel {
  final String username;
  final String location;
  final String profileImage;
  final String restaurant;
  final double rating;
  final String review;
  final String imageUrl;
  int hearts; // mutable for increment
  final String timeAgo;

  PostModel({
    required this.username,
    required this.location,
    required this.profileImage,
    required this.restaurant,
    required this.rating,
    required this.review,
    required this.imageUrl,
    required this.hearts,
    required this.timeAgo,
  });
}
