// utils/time_utils.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeUtils {
  static String getTimeAgo(dynamic timestamp) {
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
}
