//notificationbox.dart - design for the notification
import 'package:flutter/material.dart';

class NotificationBox extends StatelessWidget {
  final String profileImage;
  final String username;
  final String activity;
  final String timestamp;
  final String numseq;
  final String? notificationId; // For future functionality

  const NotificationBox({
    super.key,
    required this.profileImage,
    required this.username,
    required this.activity,
    required this.timestamp,
    required this.numseq,
    this.notificationId,
  });

  // Function to get appropriate icon based on activity type
  IconData _getActivityIcon(String activity) {
    if (activity.toLowerCase().contains('react')) {
      return Icons.favorite;
    } else if (activity.toLowerCase().contains('comment')) {
      return Icons.comment;
    } else if (activity.toLowerCase().contains('post')) {
      return Icons.add_circle;
    } else {
      return Icons.notifications;
    }
  }

  // Function to get icon color based on activity type
  Color _getIconColor(String activity) {
    if (activity.toLowerCase().contains('react')) {
      return Colors.red;
    } else if (activity.toLowerCase().contains('comment')) {
      return Colors.blue;
    } else if (activity.toLowerCase().contains('post')) {
      return Colors.green;
    } else {
      return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff2f4a5d),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(profileImage),
              radius: 24,
              onBackgroundImageError: (exception, stackTrace) {
                // Fallback if image fails to load
                return;
              },
              child: profileImage.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getIconColor(activity),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xff2f4a5d), width: 2),
                ),
                child: Icon(
                  _getActivityIcon(activity),
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity,
              style: const TextStyle(color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              timestamp,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: Colors.white),
          color: const Color(0xff2f4a5d),
          onSelected: (value) {
            if (value == 'delete') {
              // TODO: Implement delete functionality
              // You can use notificationId to delete from Firestore
              _showDeleteConfirmation(context);
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff2f4a5d),
          title: const Text(
            'Delete Notification',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to delete this notification?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement delete from Firestore
                // _databaseService.deleteNotification(notificationId!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification deleted'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
