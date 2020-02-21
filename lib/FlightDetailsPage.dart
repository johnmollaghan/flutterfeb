import 'package:flutter/material.dart';
import 'FidsData.dart';


class FlightDetailsPage extends StatelessWidget {
  final FidsData flight;

  FlightDetailsPage(this.flight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          Text(flight.remarksWithTime + " - " + flight.destinationAirportName),
          backgroundColor: Colors.lightGreen,
          elevation: 50.0,
        ));
  }
}