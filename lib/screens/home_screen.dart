import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_statuses/model/post_model.dart';
import 'package:my_statuses/screens/auth/registration_screen.dart';

import 'package:my_statuses/screens/post_status_screen.dart';
import 'package:my_statuses/utilities/constants.dart';
import 'package:my_statuses/utilities/firebase_utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User firebaseUser;

  getData() {
    firebaseUser = FirebaseAuth.instance.currentUser;
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
                onPressed: () async {
                  await FirebaseUtils.removeFirebaseToken();
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
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => PostStatusScreen()));
          },
          child: Icon(Icons.publish),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(Constants.statues)
                .orderBy("likes")
                .orderBy("timestamp", descending: true)
                .snapshots(),
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

Query getQuery() {
  Query query = FirebaseFirestore.instance
      .collection(Constants.statues)
      .where("docid", isEqualTo: "MmuEd2wRd4V1Q6mu1Ryz");
  return query;
}

class PostTile extends StatelessWidget {
  final PostModel postModel;
  PostTile({this.postModel});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          postModel.imageURL,
          height: 100,
          width: 100,
        ),
        title: Text(
          postModel.title,
          maxLines: 1,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          postModel.timestamp.toDate().toString().split(" ")[0],
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: Text("${postModel.likes} "),
      ),
    );
  }
}
