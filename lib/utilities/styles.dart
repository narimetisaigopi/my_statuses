import 'package:flutter/material.dart';

const Color appColor = Color(0xff2873f0);

Map<int, Color> color = {
  50: Color.fromRGBO(255, 92, 87, .1),
  100: Color.fromRGBO(255, 92, 87, .2),
  200: Color.fromRGBO(255, 92, 87, .3),
  300: Color.fromRGBO(255, 92, 87, .4),
  400: Color.fromRGBO(255, 92, 87, .5),
  500: Color.fromRGBO(255, 92, 87, .6),
  600: Color.fromRGBO(255, 92, 87, .7),
  700: Color.fromRGBO(255, 92, 87, .8),
  800: Color.fromRGBO(255, 92, 87, .9),
  900: Color.fromRGBO(255, 92, 87, 1),
};

MaterialColor materialAppColor = MaterialColor(0xff1fd954, color);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green, width: 2.0)),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0)),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: appColor, width: 2.0)),
);

var button = RaisedButton(
  child: Text("Rock & Roll"),
  color: Colors.red,
  textColor: Colors.yellow,
  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  splashColor: Colors.grey,
  onPressed: () {},
);

var inputDecoration = InputDecoration(border: OutlineInputBorder());
var defalutSizedBox = SizedBox(
  height: 15,
);
