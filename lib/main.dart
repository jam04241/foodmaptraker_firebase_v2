import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Loginform/getstarted.dart';
import 'package:foodtracker_firebase/firebase_options.dart';
import 'package:foodtracker_firebase/model/LocationDataScript.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //Script for marker if they will upload to firebase
  try {
    await FirebaseUploader.uploadLocationsToFirebase();
  } catch (e) {
    print('❌ Error uploading locations: $e');
  }

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
