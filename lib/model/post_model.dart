import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String docid;
  String imageURL;
  String message;
  String title;
  Timestamp? timestamp;
  int likes;

  PostModel(
      {this.docid = "",
      this.imageURL = "",
      this.message = "",
      this.title = "",
      this.timestamp,
      this.likes = 0});

  factory PostModel.fromJSON(Map<String, dynamic> map) {
    return PostModel(
        docid: map["docid"] ?? "",
        imageURL: map["imageURL"] ?? "",
        message: map["message"] ?? "",
        title: map["title"] ?? "",
        likes: map["likes"] ?? 0,
        timestamp: map["timestamp"]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['docid'] = docid;
    map['imageURL'] = imageURL;
    map['message'] = message;
    map['title'] = title;
    map['likes'] = likes;
    map["timestamp"] = FieldValue.serverTimestamp();
    return map;
  }
}
