import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_statuses/constants.dart';
import 'package:my_statuses/model/post_model.dart';
import 'package:my_statuses/screens/auth/registration_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseUser firebaseUser;

  getData() {
    FirebaseAuth.instance.currentUser().then((value) {
      setState(() {
        firebaseUser = value;
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((onValue) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RegistrationScreen()));
                  });
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.publish),
        ),
        body: StreamBuilder(
            stream:
                Firestore.instance.collection(Constants.statues).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              if (snapshot == null || snapshot.data.documents.length == 0) {
                return Center(child: Text("No Data Found"));
              }
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    PostModel postModel =
                        PostModel.fromJSON(snapshot.data.documents[index].data);
                    return PostTile(
                      postModel: postModel,
                    );
                  });
            }));
  }
}

class PostTile extends StatelessWidget {
  final PostModel postModel;
  PostTile({this.postModel});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Image.network(
        postModel.imageURL,
        height: 100,
        width: 100,
      ),
      title: Text(
        postModel.title,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        postModel.message,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
