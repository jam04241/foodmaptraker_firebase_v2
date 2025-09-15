import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Dashboard_Widget/ImageSlider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff213448),
        toolbarHeight: 100, // makes the AppBar taller
        title: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 30.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              CircleAvatar(
                radius: 28, // make avatar larger to match new size
                backgroundColor: const Color(0xffEEF3D2),
                child: ClipOval(
                  child: Image.asset(
                    'images/foodtracker.jpg',
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff213448), Color(0xff213448)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(children: const [SizedBox(height: 20), Imageslider()]),
      ),

      bottomNavigationBar: Container(
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
                onPressed: () {},
                icon: Icons.location_on,

                iconActiveColor: const Color.fromARGB(255, 255, 255, 255),
                iconSize: 52,
              ),
              GButton(icon: Icons.notifications, text: 'Notifications'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
