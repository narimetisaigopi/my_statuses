import 'package:flutter/material.dart';
import 'package:my_statuses/date_pick.dart';
import 'package:my_statuses/screens/registration_screen.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DatePicker(),
    );
  }
}
