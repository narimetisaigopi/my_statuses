import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_statuses/screens/splash_screen.dart';

void main() async {
  // Ravi modifying changes
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
   
  // stock uppdates, bank , job ,
  // firebase token
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      //_showItemDialog(message);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      //_navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      //_navigateToItemDetail(message);
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
