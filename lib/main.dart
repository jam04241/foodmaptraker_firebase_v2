import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Loginform/getstarted.dart';
import 'package:foodtracker_firebase/firebase_options.dart';
import 'package:foodtracker_firebase/model/LocationDataScript.dart';
import 'package:foodtracker_firebase/model/firebase_collection_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('🚀 Starting Firebase initialization...');

  try {
    // Initialize all collections first
    await FirebaseCollectionInitializer.initializeAllCollections();
    print('✅ Collections initialized successfully');

    // Then upload locations
    await FirebaseUploader.uploadLocationsToFirebase();
    print('✅ Locations uploaded successfully');

    print('🎉 All Firebase setup completed!');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
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
