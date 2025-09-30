import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Widget/bottomNav.dart';
import 'package:foodtracker_firebase/Mobile/Dashboard.dart';
import 'package:foodtracker_firebase/Mobile/Trending.dart';
import 'package:foodtracker_firebase/Mobile/Location.dart';
import 'package:foodtracker_firebase/Mobile/Notifications.dart';
import 'package:foodtracker_firebase/Mobile/ProfilePage.dart';

class Mainframe extends StatefulWidget {
  const Mainframe({super.key});

  @override
  State<Mainframe> createState() => _MainframeState();
}

class _MainframeState extends State<Mainframe> {
  int selectedIndex = 0;

  // List of pages to show
  final List<Widget> pages = const [
    NavDashboardPage(),
    NavTrendingPage(),
    NavLocationPage(),
    NavNotificationsPage(),
    NavProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main background color
      backgroundColor: const Color(0xff213448),

      body: pages[selectedIndex], // ✅ swap body based on index

      bottomNavigationBar: ButtomNavbar(
        selectedIndex: selectedIndex,
        onTabChange: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
