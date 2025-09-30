import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Loginform/getstarted.dart';
import 'package:foodtracker_firebase/firebase_options.dart';
<<<<<<< HEAD
// import 'package:foodtracker_firebase/Mobile/Mainframe.dart';
=======
>>>>>>> origin/master

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Homepage(),
    );
  }
}
