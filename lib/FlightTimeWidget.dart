import 'package:flutter/material.dart';

import 'FidsData.dart';

class FlightTimeWidget extends StatelessWidget {
  const FlightTimeWidget({
    Key key,
    @required this.flight,
  }) : super(key: key);

  final FidsData flight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("SCHEDULED"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    flight.getScheduledTime(),
                    style: TextStyle(
                      fontSize: 22.0,
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
                  child: Text("ESTIMATED"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    flight.getEstimatedTime(),
                    style: TextStyle(
                      fontSize: 22.0,
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
                  child: Text("ACTUAL"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    flight.getActualTime(),
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
