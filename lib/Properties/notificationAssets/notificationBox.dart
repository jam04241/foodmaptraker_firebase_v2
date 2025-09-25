import 'package:flutter/material.dart';

class NotificationBox extends StatelessWidget {
  final String profileImage;
  final String username;
  final String activity;
  final String timestamp;
  // For function in Sort BY: Button
  final String numseq;

  const NotificationBox({
    super.key,
    required this.profileImage,
    required this.username,
    required this.activity,
    required this.timestamp,
    required this.numseq,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff2f4a5d),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(profileImage),
          radius: 24,
        ),
        title: Text(
          username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity, style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Text(
              timestamp,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz, color: Colors.white),
          onPressed: () {
            // 👉 Optional: add popup menu or action here
          },
        ),
      ),
    );
  }
}
