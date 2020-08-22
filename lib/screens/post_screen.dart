import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:my_statuses/model/post_model.dart';
import 'package:my_statuses/utilities/constants.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  File image;

  GlobalKey<ScaffoldState> globalScaffoldState = GlobalKey();

  PostModel postModel;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldState,
      appBar: AppBar(
        title: Text("Post Status"),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                TextField(
                  controller: titleController,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Title",
                      labelText: "Title"),
                ),
                TextField(
                  controller: messageController,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Message",
                      labelText: "Message"),
                ),
                RaisedButton(
                  onPressed: () {
                    validate();
                  },
                  child: Text("Post"),
                )
              ],
            ),
    );
  }

  void validate() async {
    if (titleController.text.length == 0) {
      globalScaffoldState.currentState
          .showSnackBar(SnackBar(content: Text("Enter title")));
      return;
    }
    if (messageController.text.length == 0) {
      globalScaffoldState.currentState
          .showSnackBar(SnackBar(content: Text("Enter Message")));
      return;
    }

    postModel.title = titleController.text;
    postModel.message = messageController.text;
  }

  Future<bool> postStatus() async {
    setState(() {
      isLoading = true;
    });
    DocumentReference documentReference =
        Firestore.instance.collection(Constants.statues).document();
    await documentReference.setData(postModel.toMap());
    setState(() {
      isLoading = false;
    });
  }
}
