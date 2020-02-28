import 'package:flutter/material.dart';


class FlightSearchPage extends StatelessWidget {

  FlightSearchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Flight Number",
                icon: Icon(Icons.person),
                border: UnderlineInputBorder(),
                filled: true,
                hintText: "",
              ),

            )
          ],
        ),
      ),
        appBar: AppBar(
          title:
          Text("Flight Search"),
          backgroundColor: Colors.amber,
          elevation: 50.0,
        ));
  }
}