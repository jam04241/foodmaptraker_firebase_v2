// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Loginform/log_register.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff213448), Color(0xff1a2c3a)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔹 Top Section
                Column(
                  children: [
                    const Text(
                      "Welcome to FoodTracker",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('images/foodtracker.jpg'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Track your meals, discover healthy recipes, and stay motivated on your wellness journey. FoodTracker helps you make smarter choices every day.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                  ),
                ),

                // 🔹 Middle Section (Description)

                // 🔹 Bottom Section (Get Started Button)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginDesign(),
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [Color(0xff4e6e8e), Color(0xff213448)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
