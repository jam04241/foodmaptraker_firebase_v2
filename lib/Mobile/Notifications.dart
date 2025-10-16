//notification.dart - the main page for notification
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodtracker_firebase/Properties/notificationAssets/notificationBox.dart';
import 'package:foodtracker_firebase/services/database_service.dart'; // Import your service

class NavNotificationsPage extends StatefulWidget {
  const NavNotificationsPage({super.key});

  @override
  State<NavNotificationsPage> createState() => _NavNotificationsPageState();
}

class _NavNotificationsPageState extends State<NavNotificationsPage> {
  String sortOrder = "Newest"; // Default sort option
  final DatabaseService _databaseService = DatabaseService();

  // Firestore query for notifications
  Stream<QuerySnapshot> get notificationsStream {
    if (sortOrder == "Newest") {
      return FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('numseq', descending: true) // Newest first (highest numseq)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('numseq', descending: false) // Oldest first (lowest numseq)
          .snapshots();
    }
  }

  void _sortNotifications(String value) {
    setState(() {
      sortOrder = value;
    });
    // The stream will automatically update due to the getter
  }

  // Helper function to format timestamp
  String getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final postTime = timestamp.toDate();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff213448),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: const Color(0xff213448),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            "Notifications",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // Dropdown inside body
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: DropdownButton<String>(
              dropdownColor: const Color(0xff2f4a5d),
              value: sortOrder,
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "Newest", child: Text("Newest")),
                DropdownMenuItem(value: "Oldest", child: Text("Oldest")),
              ],
              onChanged: (value) {
                if (value != null) {
                  _sortNotifications(value);
                }
              },
            ),
          ),

          // Expanded list of notifications from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: notificationsStream,
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
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your notifications will appear here',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final notifications = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final data = notification.data() as Map<String, dynamic>;

                    return NotificationBox(
                      profileImage:
                          'images/defaultProfile.png', // Default image
                      username: data['username'] ?? 'User',
                      activity: data['message'] ?? 'New activity',
                      timestamp: getTimeAgo(data['createAt'] as Timestamp),
                      numseq: data['numseq'].toString(),
                      // You can add more fields if needed
                      notificationId:
                          notification.id, // For potential delete functionality
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
