import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String mobileNumber;
  String email;
  Timestamp timestamp;
  String uid;
  // bool isMale;
  // int age;

  // 2nd part
  UserModel(
      {this.name, this.mobileNumber, this.email, this.timestamp, this.uid});

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
      'timestamp': FieldValue.serverTimestamp()
    };
  }

  // 4th part - from map to model object

  factory UserModel.fromMap(Map map) {
    return UserModel(
      name: map["name"],
      mobileNumber: map["mobileNumber"],
      email: map["email"],
      timestamp: map["timestamp"],
      uid: map["uid"],
    );
  }
}
