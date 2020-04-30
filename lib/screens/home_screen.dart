import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_statuses/screens/registration_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){

          FirebaseAuth.instance.signOut().then((onValue){
          Navigator.push(context, MaterialPageRoute(builder: (_) => RegistrationScreen() ));

          });

        })
      ],),
    );
  }
}