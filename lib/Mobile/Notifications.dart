import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Properties/notificationAssets/notificationBox.dart';

class NavNotificationsPage extends StatefulWidget {
  const NavNotificationsPage({super.key});

  @override
  State<NavNotificationsPage> createState() => _NavNotificationsPageState();
}

class _NavNotificationsPageState extends State<NavNotificationsPage> {
  String sortOrder = "Newest"; // Default sort option

  List<Map<String, dynamic>> notifications = [
    {
      "profileImage": "images/post6.jpg",
      "username": "Stephen Tatskie",
      "activity": "Reacted to your Review",
      "timestamp": "1h ago",
      "numseq": 1,
    },
    {
      "profileImage": "images/mommyjupeta.jpg",
      "username": "Mommy Jupeta",
      "activity": "commented on your photo",
      "timestamp": "2h ago",
      "numseq": 2,
    },
    {
      "profileImage": "images/JL.jpg",
      "username": "John Hope Lloyd",
      "activity": "React to your Review",
      "timestamp": "3h ago",
      "numseq": 3,
    },
    {
      "profileImage": "images/JL.jpg",
      "username": "John Hope Lloyd",
      "activity": "Reacted to your Review",
      "timestamp": "4h ago",
      "numseq": 4,
    },
    {
      "profileImage": "images/mommyjupeta.jpg",
      "username": "Mommy Jupeta",
      "activity": "commented on your Review",
      "timestamp": "5h ago",
      "numseq": 5,
    },
  ];

  void _sortNotifications() {
    setState(() {
      if (sortOrder == "Newest") {
        notifications.sort((a, b) => a["numseq"].compareTo(b["numseq"]));
      } else {
        notifications.sort((a, b) => b["numseq"].compareTo(a["numseq"]));
      }
    });
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
                  setState(() {
                    sortOrder = value;
                  });
                  _sortNotifications();
                }
              },
            ),
          ),

          // Expanded list of notifications
          Expanded(
            child: ListView(
              children: notifications
                  .map(
                    (n) => NotificationBox(
                      profileImage: n["profileImage"],
                      username: n["username"],
                      activity: n["activity"],
                      timestamp: n["timestamp"],
                      numseq: n["numseq"].toString(),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
