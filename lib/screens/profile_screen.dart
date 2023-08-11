import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_statuses/model/user_model.dart';
import 'package:my_statuses/screens/home_screen.dart';
import 'package:my_statuses/utilities/firebase_utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _email = "", _password = "", _name = "", _mobile = "";

  var _formkey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool isLoading = false;
  UserModel userModel = UserModel();

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController mobileNumberTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();

  @override
  void initState() {
    FirebaseUtils.usersCollectionsReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        userModel = UserModel.fromMap(value.data() as Map<String, dynamic>);
        nameTextEditingController.text = userModel.name;
        emailTextEditingController.text = userModel.email;
        mobileNumberTextEditingController.text = userModel.mobileNumber;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Form(
                    key: _formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          child: userModel.profilePic.isNotEmpty
                              ? Image.network(userModel.profilePic)
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: nameTextEditingController,
                          keyboardType: TextInputType.text,
                          validator: (item) {
                            return item!.length > 0 ? null : "Enter valid Name";
                          },
                          onChanged: (item) {
                            setState(() {
                              _name = item;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Enter Name",
                              labelText: "Name",
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: mobileNumberTextEditingController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (item) {
                            return item!.length < 10
                                ? "Enter valid Mobile"
                                : null;
                          },
                          onChanged: (item) {
                            setState(() {
                              _mobile = item;
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              hintText: "Enter Mobile Number",
                              labelText: "Mobile Number",
                              counterText: "",
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (item) {
                            return item!.contains("@")
                                ? null
                                : "Enter valid Email";
                          },
                          onChanged: (item) {
                            setState(() {
                              _email = item;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Enter Email",
                              labelText: "Email",
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              signup();
                            },
                            child: Text(
                              "Update Profile",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              ),
            ),
    );
  }

  void signup() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      setState(() {
        autoValidate = false;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        // sign up
        postUserDataToDb();
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "error " + onError.toString());
      });
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  void postUserDataToDb() async {
    setState(() {
      isLoading = true;
    });

    //FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    User firebaseUser = FirebaseAuth.instance.currentUser!;

    UserModel userModel = new UserModel();
    userModel.email = _email;
    userModel.name = _name;
    userModel.mobileNumber = _mobile;
    userModel.uid = firebaseUser.uid;

    await FirebaseFirestore.instance
        .collection("user")
        .doc(firebaseUser.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Register Success");

    await FirebaseUtils.updateFirebaseToken();

    sendVerificationEmail();

    setState(() {
      isLoading = false;
    });
  }

  void sendVerificationEmail() async {
    //FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    await firebaseUser.sendEmailVerification();

    Fluttertoast.showToast(
        msg: "email verifcation link has sent to your email.");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (Route<dynamic> route) => false);
  }
}
