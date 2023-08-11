import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_statuses/screens/splash_screen.dart';

void main() async {
  // here i am making changes
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // stock uppdates, bank , job ,
  // firebase token
  // firebaseMessaging.configure(
  //   onMessage: (Map<String, dynamic> message) async {
  //     print("onMessage: $message");
  //     //_showItemDialog(message);
  //   },
  //   onLaunch: (Map<String, dynamic> message) async {
  //     print("onLaunch: $message");
  //     //_navigateToItemDetail(message);
  //   },
  //   onResume: (Map<String, dynamic> message) async {
  //     print("onResume: $message");
  //     //_navigateToItemDetail(message);
  //   },
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: SplashScreen(),
    );
  }
}
