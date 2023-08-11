import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String mobileNumber;
  String email;
  var timestamp;
  String uid;
  String profilePic;
  // bool isMale;
  // int age;

  // 2nd part
  UserModel(
      {this.name = "",
      this.mobileNumber = "",
      this.email = "",
      this.timestamp = "",
      this.profilePic = "",
      this.uid = ""});

  //3rd creating map -- insert
  toMap() {
    // Map map = Map();
    // map["name"] = name;
    // return map;

    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'email': email,
      'uid': uid,
      'profilePic': profilePic,
      'timestamp': FieldValue.serverTimestamp()
    };
  }

  // 4th part - from map to model object

  factory UserModel.fromMap(Map map) {
    return UserModel(
        name: map["name"] ?? "",
        mobileNumber: map["mobileNumber"] ?? "",
        email: map["email"] ?? "",
        timestamp: map["timestamp"] ?? "",
        uid: map["uid"] ?? "",
        profilePic: map['profilePic'] ?? "");
  }
}
