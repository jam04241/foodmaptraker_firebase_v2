import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Properties/dashboardAssets/ImageSlider.dart';
import 'package:foodtracker_firebase/Properties/dashboardAssets/foodDescription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavDashboardPage extends StatefulWidget {
  const NavDashboardPage({super.key});

  @override
  State<NavDashboardPage> createState() => _NavDashboardPageState();
}

class _NavDashboardPageState extends State<NavDashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = "User"; // Default value
  String _userEmail = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _userName = userData['userName'] ?? 'User';
            _userEmail = userData['email'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: const Color(0xff213448),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    _userName, // ✅ Dynamic username from Firebase
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userEmail.isNotEmpty ? _userEmail : "Welcome back 👋",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xffEEF3D2),
                  child: ClipOval(
                    child: Image.asset(
                      'images/foodtracker.jpg',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
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
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            const ImageSlider(),
            const SizedBox(height: 20),
            const Text(
              'Recommended Meals',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Meal 1
            Card(
              color: const Color(0xff2f4a5d),
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'images/food1.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text(
                  'Grilled Chicken Salad',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Fresh greens with protein',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 16,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Fooddescription(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 🔹 Meal 2
            Card(
              color: const Color(0xff2f4a5d),
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'images/food2.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text(
                  'Avocado Toast',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Simple and nutritious',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 16,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Fooddescription(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
