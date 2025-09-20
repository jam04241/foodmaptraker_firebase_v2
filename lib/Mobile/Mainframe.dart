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
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   toolbarHeight: 100,
      //   backgroundColor: const Color(0xff213448),
      //   title: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: const [
      //             SizedBox(height: 4),
      //             Text(
      //               "Welcome back 👋",
      //               style: TextStyle(
      //                 fontFamily: 'Montserrat',
      //                 color: Colors.white70,
      //                 fontSize: 14,
      //               ),
      //             ),
      //           ],
      //         ),

      //         Container(
      //           decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //             border: Border.all(color: Colors.white70, width: 2),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.black.withOpacity(0.3),
      //                 blurRadius: 8,
      //                 offset: const Offset(0, 4),
      //               ),
      //             ],
      //           ),
      //           child: CircleAvatar(
      //             radius: 28,
      //             backgroundColor: const Color(0xffEEF3D2),
      //             child: ClipOval(
      //               child: Image.asset(
      //                 'images/foodtracker.jpg',
      //                 width: 40,
      //                 height: 40,
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
