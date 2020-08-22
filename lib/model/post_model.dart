import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String docid;
  String imageURL;
  String message;
  String title;
  Timestamp timeStamp;
  PostModel(
      {this.docid, this.imageURL, this.message, this.title, this.timeStamp});

  factory PostModel.fromJSON(Map<String, dynamic> map) {
    return PostModel(
        docid: map["docid"],
        imageURL: map["imageURL"],
        message: map["message"],
        title: map["title"],
        timeStamp: map["timeStamp"]);
  }

  toMap() {
    Map<String, dynamic> map = Map();
    map['docid'] = docid;
    map['imageURL'] = imageURL;
    map['message'] = message;
    map['title'] = title;
    map["timeStamp"] = FieldValue.serverTimestamp();
  }
}
