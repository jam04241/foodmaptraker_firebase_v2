import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ButtomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const ButtomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: GNav(
        backgroundColor: Color(0xff213448),
        color: Colors.white,
        tabBackgroundColor: const Color(0xff94b4c1),
        activeColor: Colors.white,
        gap: 30,
        padding: const EdgeInsets.all(16),
        selectedIndex: selectedIndex,
        onTabChange: onTabChange, // ✅ send selected index back
        tabs: const [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.trending_up, text: 'Trending'),
          GButton(icon: Icons.location_on, text: 'Location'),
          GButton(icon: Icons.notifications, text: 'Notifications'),
          GButton(icon: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }
}
