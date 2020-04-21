import 'package:flutter/material.dart';
import 'package:flutterfeb/FlightArrivalWidget.dart';
import 'package:flutterfeb/FlightDepartureWidget.dart';

import 'FidsData.dart';

class FlightDetailsPage extends StatelessWidget {
  final FidsData flight;

  FlightDetailsPage(this.flight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              topRowDetails(flight: flight),
              Chip(
                label: Text(
                  flight.getFlightstatus(),
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: flight.getStatusColor(),
              ),
              Card(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "DEPARTURE INFORMATION" + " " + flight.getCodeShares().toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              FlightDepartureWidget(flight: flight),
              Card(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ARRIVAL INFORMATION",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              FlightArrivalWidget(flight: flight),
            ],
          ),
        ),
        appBar: AppBar(
          title:
              Text(flight.getFlightNumber() + " - " + flight.getAirlineName()),
          backgroundColor: flight.getStatusColor(),
          elevation: 50.0,
        ));
  }
}

class topRowDetails extends StatelessWidget {
  const topRowDetails({
    Key key,
    @required this.flight,
  }) : super(key: key);

  final FidsData flight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text("DEPARTING FROM"),
                Text(
                  flight.getDepartureAirportCode(),
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward),
          Container(
            child: Column(
              children: <Widget>[
                Text("ARRIVING TO"),
                Text(
                  flight.getArrivalAirportCode(),
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
