import 'package:flutter/material.dart';

import 'FidsData.dart';

class FlightDetailsPage extends StatelessWidget {
  final FidsData flight;

  FlightDetailsPage(this.flight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text("FROM"),
                        Text(
                          flight.originAirportCode,
                          style: TextStyle(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text("TO"),
                        Text(
                          flight.destinationAirportCode,
                          style: TextStyle(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            Chip(label: Text(flight.remarksWithTime)),

            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("ORIGIN AIRPORT - " + flight.originAirportCode),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      flight.originCity,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      flight.originAirportName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "ORIGIN AIRPORT - " + flight.destinationAirportCode),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      flight.destinationCity,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      flight.destinationAirportName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(flight.airlineName + " " + flight.flightNumber),
          backgroundColor: Colors.lightGreen,
          elevation: 50.0,
        ));
  }
}
