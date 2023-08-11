import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_statuses/screens/auth/forgot_pasword.dart';
import 'package:my_statuses/screens/home_screen.dart';
import 'package:my_statuses/screens/auth/registration_screen.dart';
import 'package:my_statuses/utilities/firebase_utils.dart';

import '../../model/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "", _password = "";

  var _formkey = GlobalKey<FormState>();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
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
                        TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          validator: (item) {
                            return item!.length > 6
                                ? null
                                : "Password must be 6 characters";
                          },
                          onChanged: (item) {
                            setState(() {
                              _password = item;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Enter Password",
                              labelText: "Password",
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              login();
                            },
                            child: Text(
                              "Login",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RegistrationScreen()));
                            },
                            child: Text(
                              "Register",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("Forgot Password?")),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ForgotPasswordScreen()));
                          },
                        ),
                        FlutterSocialButton(
                          onTap: () {
                            googleSignIn();
                          },
                          buttonType: ButtonType
                              .google, // Button type for different type buttons
                        ),
                      ],
                    )),
              ),
            ),
    );
  }

  void googleSignIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);

        User firebaseUser = FirebaseAuth.instance.currentUser!;

        UserModel userModel = new UserModel();
        userModel.email = firebaseUser.email ?? "";
        userModel.name = firebaseUser.displayName ?? "";
        userModel.profilePic = firebaseUser.photoURL ?? "";
        userModel.uid = firebaseUser.uid;

        await FirebaseFirestore.instance
            .collection("user")
            .doc(firebaseUser.uid)
            .set(userModel.toMap());

        // update user data to fire

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void login() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) async {
        // sign up
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "Login Success");

        await FirebaseUtils.updateFirebaseToken();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
            (Route<dynamic> route) => false);
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "error " + onError.toString());
      });
    }
  }
}
