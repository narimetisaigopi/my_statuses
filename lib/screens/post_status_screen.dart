import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_statuses/model/post_model.dart';
import 'package:my_statuses/utilities/circle_loading.dart';
import 'package:my_statuses/utilities/constants.dart';
import 'package:my_statuses/utilities/firebase_utils.dart';
import 'package:my_statuses/utilities/styles.dart';

class PostStatusScreen extends StatefulWidget {
  @override
  _PostStatusScreenState createState() => _PostStatusScreenState();
}

class _PostStatusScreenState extends State<PostStatusScreen> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController messageEditingController = TextEditingController();

  bool isLoading = false;

  late PostModel postModel;

  late BuildContext context;
  var globalKey = GlobalKey<ScaffoldState>();

  String _imagePath = "";
  Future<File>? imageFile;

  @override
  void initState() {
    super.initState();

    postModel = PostModel();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text("Post Status"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              showImage(),
              ElevatedButton(
                onPressed: () {
                  pickImagesFromGallery(ImageSource.gallery);
                },
                child: Text("Select image"),
              ),
              defalutSizedBox,
              TextField(
                controller: titleEditingController,
                textInputAction: TextInputAction.next,
                minLines: 2,
                maxLines: 100,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                    labelText: "Title",
                    counterText: "",
                    hintText: "Enter Title",
                    border: OutlineInputBorder()),
              ),
              defalutSizedBox,
              TextField(
                controller: messageEditingController,
                textInputAction: TextInputAction.next,
                minLines: 5,
                maxLines: 100,
                textAlign: TextAlign.start,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                    labelText: "Description",
                    counterText: "",
                    hintText: "Enter Description",
                    border: OutlineInputBorder()),
              ),
              defalutSizedBox,
              isLoading
                  ? MyCircleLoading()
                  : Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          var timeStamp =
                              FieldValue.serverTimestamp().toString();
                          print("timeStamp: $timeStamp");
                          validateMobileNumber();
                        },
                        child: Text(
                          "Post",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void validateMobileNumber() async {
    FocusScope.of(context).unfocus();

    if (titleEditingController.text.isEmpty ||
        titleEditingController.text.length == 0) {
      Fluttertoast.showToast(msg: "Enter title");
      return;
    }

    if (messageEditingController.text.isEmpty ||
        messageEditingController.text.length == 0) {
      Fluttertoast.showToast(msg: "Enter description");

      return;
    }

    post();
  }

  void post() async {
    setState(() {
      isLoading = true;
    });

    try {
      postModel.title = titleEditingController.text;
      postModel.message = messageEditingController.text;

      int id = 0;

      DocumentReference countDocumentReference = FirebaseFirestore.instance
          .collection(Constants.count)
          .doc(Constants.count);

      FirebaseUtils.postNotification(postModel, _imagePath);

      // notificationModel.docId = postDocumentReference.documentID;
      // await postDocumentReference.setData(notificationModel.toMap());

      if (id == 0) {
        await countDocumentReference.set({"id": id});
      } else {
        await countDocumentReference.update({"id": id});
      }

      Fluttertoast.showToast(msg: "Posted successfully.");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Post failed due to : $e.");
    }

    setState(() {
      isLoading = false;
    });
  }

  pickImagesFromGallery(ImageSource source) {
    setState(() {
      ImagePicker().pickImage(source: source).then((onValue) {
        setState(() {
          _imagePath = onValue!.path;
          print("_imagePath : " + _imagePath);
        });
      });
    });
  }

  showImage() {
    print("showImage : " + postModel.imageURL.toString());

    if (imageFile != null) {
      return FutureBuilder<File>(
          future: imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Image.file(snapshot.data!, width: 250, height: 250);
            } else if (snapshot.error != null) {
              print("snapshot.error : ${snapshot.error} ");
              return Text("Error Picking Image", textAlign: TextAlign.center);
            } else {
              return Text("No Image Selected", textAlign: TextAlign.center);
            }
          });
    } else {
      if (postModel.docid.isNotEmpty && postModel.imageURL.isNotEmpty) {
        return Image.network(postModel.imageURL, width: 250, height: 250);
      } else
        return Text("No Image Selected", textAlign: TextAlign.center);
    }
  }
}
