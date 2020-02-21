import 'package:flutter/material.dart';


class FlightSearchPage extends StatelessWidget {

  FlightSearchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          Text("Flight Search"),
          backgroundColor: Colors.red,
          elevation: 50.0,
        ));
  }
}