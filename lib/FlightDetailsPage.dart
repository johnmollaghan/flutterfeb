import 'package:flutter/material.dart';
import 'FlightTimeWidget.dart';

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
                  flight.getRemarksWithTime() +
                      " - " +
                      flight.getStatusCode() +
                      " - " +
                      flight.getRemarksCode(),
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: flight.getStatusColor(),
              ),
              FlightTimeWidget(flight: flight),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("FROM"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        flight.getOriginCity(),
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        flight.getOriginAirportName(),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("TO"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        flight.getDestinationCity(),
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        flight.getDestinationAirportName(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("TERMINAL"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              flight.getTerminal(),
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("GATE"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              flight.getGate(),
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("BAGGAGE"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              flight.getBaggage(),
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(flight.getAirlineName() + " " + flight.getAirlineCode() + flight.getFlightNumber()),
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
                Text("FROM"),
                Text(
                  flight.getOriginAirportCode(),
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
                  flight.getDestinationAirportCode(),
                  style: TextStyle(
                      fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
