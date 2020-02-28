import 'package:flutter/material.dart';


class AirportPickerPage extends StatelessWidget {

  AirportPickerPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          Text("Airport Picker"),
          backgroundColor: Colors.indigo,
          elevation: 50.0,
        ));
  }
}