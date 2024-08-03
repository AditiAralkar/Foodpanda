import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/global/global.dart';
import 'package:project/splashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized() ;
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    // Replace with actual values
      options: const FirebaseOptions(
          apiKey: "AIzaSyAiGKKaV-XbvJS3818ZHaiHllMy15EphiA",
          appId: "1:701006064927:android:9d96b61b50824ee595d42a",
          messagingSenderId: "701006064927",
          projectId: "foodpanda-1f5c1",
          storageBucket: "foodpanda-1f5c1.appspot.com",
          ),
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sellers App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MySplashScreen(),
    );
  }
}