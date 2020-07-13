import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime dateTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () async {
                pickDate(context);
              },
              child: Text("Pick Date"),
            ),
            Text("dateTimePicked: " + dateTime.toString().split(" ")[0])
          ],
        ),
      ),
    );
  }

  pickDate(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1995),
            lastDate: DateTime(2030))
        .then((value) {
      setState(() {
        dateTime = value;
      });
    });
  }
}
