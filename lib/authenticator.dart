import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/LOGINFORM/login.dart';
import 'package:foodtracker_firebase/Mobile/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticator extends StatefulWidget {
  const Authenticator({super.key});

  @override
  State<Authenticator> createState() => _AuthenticatorState();
}

class _AuthenticatorState extends State<Authenticator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (snapshot.hasData) {
            return const Dashboard();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
