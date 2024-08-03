import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:usersapp/assistantMethods/address_changer.dart';
import 'package:usersapp/assistantMethods/cart_Item_counter.dart';
import 'package:usersapp/assistantMethods/total_amount.dart';
import 'package:usersapp/splashScreens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'global/global.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyAiGKKaV-XbvJS3818ZHaiHllMy15EphiA",
      appId: "1:701006064927:android:101a2dd5b428d04c95d42a",
      messagingSenderId: "701006064927",
      projectId: "foodpanda-1f5c1",
      storageBucket: "foodpanda-1f5c1.appspot.com",
    ),
  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c)=> CartItemCounter()),
        ChangeNotifierProvider(create: (c)=> TotalAmount()),
        ChangeNotifierProvider(create: (c)=> AddressChanger()),
      ],
      child: MaterialApp(
        title: 'Users App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MySplashScreen(),
      ),
    );
  }
}


