import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ButtomNavbar extends StatefulWidget {
  const ButtomNavbar({super.key});

  @override
  State<ButtomNavbar> createState() => _ButtomNavbarState();
}

class _ButtomNavbarState extends State<ButtomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff213448), Color(0xff213448)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          tabBackgroundColor: const Color(0xff94b4c1),
          activeColor: Colors.white,
          gap: 30,
          padding: const EdgeInsets.all(16),
          tabs: [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.trending_up, text: 'Trending'),
            GButton(
              icon: Icons.location_on,
              iconActiveColor: Colors.white,
              iconSize: 52,
              text: 'Location',
            ),
            GButton(icon: Icons.notifications, text: 'Notifications'),

            GButton(
              icon: Icons.person,
              text: 'Profile',
              onPressed: () {
                // Handle profile button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
