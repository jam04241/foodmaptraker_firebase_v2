import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Loginform/log_register.dart';

class NavProfilePage extends StatefulWidget {
  const NavProfilePage({super.key});

  @override
  State<NavProfilePage> createState() => _NavProfilePageState();
}

class _NavProfilePageState extends State<NavProfilePage> {
  final TextEditingController username = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = "User";
  String _userEmail = "user@example.com";

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
        } else {
          // If user document doesn't exist, use auth data
          setState(() {
            _userName = user.displayName ?? 'User';
            _userEmail = user.email ?? '';
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _updateUsername(String newUsername) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null && newUsername.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update({
          'userName': newUsername,
        });
        setState(() {
          _userName = newUsername;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating username: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void openEditProfileModal() {
    username.text = _userName; // Pre-fill with current username

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5, // Reduced height since we only have username
          minChildSize: 0.4,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F4A5D),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF2F4A5D),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Input Fields
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      children: [
                        // Username Only
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: username,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              hintText: "Username",
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2F4A5D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Confirm Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF547792),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          _updateUsername(username.text.trim());
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Update Username",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff213448),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Profile Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipOval(
                    child: Image.asset('images/doctor.png', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName, // ✅ Dynamic username from Firebase
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _userEmail, // ✅ Dynamic email from Firebase
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(color: Colors.white70, thickness: 1.5),
            const SizedBox(height: 10),

            // Settings Card
            Card(
              color: const Color(0xff2f4a5d),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 16,
                  ),
                  onPressed:
                      openEditProfileModal, // Updated to new function name
                ),
              ),
            ),

            //Favorite button card
            Card(
              color: const Color(0xff2f4a5d),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ListTile(
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 28,
                ),
                title: const Text(
                  'Favorite',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 18,
                  ),
                  onPressed: () {},
                ),
              ),
            ),

            //Posted button card
            Card(
              color: const Color(0xff2f4a5d),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ListTile(
                leading: const Icon(
                  Icons.post_add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                title: const Text(
                  'Posted',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 18,
                  ),
                  onPressed: () {},
                ),
              ),
            ),

            // Logout Card
            Card(
              color: const Color(0xff2f4a5d),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 28,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginDesign(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
