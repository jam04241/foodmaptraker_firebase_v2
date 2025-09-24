import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Properties/notificationAssets/notificationBox.dart';

class NavNotificationsPage extends StatefulWidget {
  const NavNotificationsPage({super.key});

  @override
  State<NavNotificationsPage> createState() => _NavNotificationsPageState();
}

class _NavNotificationsPageState extends State<NavNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      // 👉 Just show one NotificationBox for now
      body: ListView(
        children: const [
          NotificationBox(),
          NotificationBox(),
          NotificationBox(),
        ],
      ),
    );
  }
}
