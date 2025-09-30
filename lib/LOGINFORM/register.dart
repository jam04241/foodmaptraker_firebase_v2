import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Loginform/log_register.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String errorMessage = "";
  bool isError = false;
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = "Passwords do not match";
        isError = true;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Success → go to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginDesign()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "An unknown error occurred";
        isError = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = "An unknown error occurred";
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 40),

                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.fastfood_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (isError) const SizedBox(height: 20),
                      if (isError)
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Username
                      _buildTextField(
                        usernameController,
                        Icons.account_circle,
                        "Create your Username",
                      ),
                      const SizedBox(height: 20),

                      // Email
                      _buildTextField(
                        emailController,
                        Icons.email,
                        "Email Address",
                      ),
                      const SizedBox(height: 20),

                      // Password
                      _buildTextField(
                        passwordController,
                        Icons.lock,
                        "Enter your Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      _buildTextField(
                        confirmPasswordController,
                        Icons.lock_outline,
                        "Confirm Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),

                      // Error message

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xff141e30), Color(0xff243b55)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ElevatedButton(
                            onPressed: register, // <-- your register function
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size(400, 60),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: const BorderSide(
                                  // White border
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: Colors
                                    .white, // white text fits gradient better
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String hint, {
    bool obscureText = false,
  }) {
    return SizedBox(
      width: 500,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefix: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
