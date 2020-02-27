import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "main.dart";

class FidsData {
  String flightId;
  String statusCode;
  String gate;
  String terminal;
  String baggage;
  String airlineName;
  String airlineCode;
  String flightNumber;
  String originAirportName;
  String originAirportCode;
  String originCity;
  String originCountryCode;
  String destinationAirportName;
  String destinationAirportCode;
  String destinationCity;
  String destinationCountryCode;
  bool delayed;
  String remarksWithTime;
  String remarksCode;
  String scheduledTime;
  String scheduledDate;
  String estimatedTime;
  String estimatedDate;
  String actualTime;
  String actualDate;
  List<String> codesharesAsNames;
  List<String> codesharesAsCodes;

  FidsData(
      this.flightId,
      this.statusCode,
      this.gate,
      this.terminal,
      this.baggage,
      this.airlineName,
      this.airlineCode,
      this.flightNumber,
      this.originAirportName,
      this.originAirportCode,
      this.originCity,
      this.originCountryCode,
      this.destinationAirportName,
      this.destinationAirportCode,
      this.destinationCity,
      this.destinationCountryCode,
      this.delayed,
      this.remarksWithTime,
      this.remarksCode,
      this.scheduledTime,
      this.scheduledDate,
      this.estimatedTime,
      this.estimatedDate,
      this.actualTime,
      this.actualDate
      /*this.codesharesAsNames,
      this.codesharesAsCodes
      */
      );

  String getActualDate() {
    if (actualDate == null) {
      return "-";
    } else {
      return actualDate;
    }
  }

  String getActualTime() {
    if (actualTime == null) {
      return "-";
    } else {
      return actualTime;
    }
  }

  String getAirportCode(String flightType) {
    if (flightType == "arrivals") {
      return originAirportCode;
    } else {
      return destinationAirportCode;
    }
  }

  String getAirportCity(String flightType) {
    if (flightType == "arrivals") {
      return originCity;
    } else {
      return destinationCity;
    }
  }

  String getAirportName(String flightType) {
    if (flightType == "arrivals") {
      return originAirportName;
    } else {
      return destinationAirportName;
    }
  }

  String getBaggage() {
    if (baggage == null) {
      return "-";
    } else {
      return baggage;
    }
  }

  String getEstimatedDate() {
    if (estimatedDate == null) {
      return "-";
    } else {
      return estimatedDate;
    }
  }

  String getEstimatedTime() {
    if (estimatedTime == null) {
      return "-";
    } else {
      return estimatedTime;
    }
  }

  String getGate() {
    if (gate == null) {
      return "-";
    } else {
      return gate;
    }
  }

  String getScheduledDate() {
    if (scheduledDate == null) {
      return "-";
    } else {
      return scheduledDate;
    }
  }

  String getScheduledTime() {
    if (scheduledTime == null) {
      return "-";
    } else {
      return scheduledTime;
    }
  }

  Color getStatusColor() {
    switch (remarksCode) {
      case "ARRIVED_ON_TIME":
        {
          // statements;
          return Colors.green;
        }

      case "DEPARTED_ON_TIME":
        {
          // statements;
          return Colors.green;
        }

      case "DEPARTED_LATE":
        {
          // statements;
          return Colors.orange;
        }

      case "ARRIVED_LATE":
        {
          // statements;
          return Colors.orange;
        }

      case "ARRIVAL_DELAYED":
        {
          // statements;
          return Colors.orange;
        }
        break;

      case "ON_TIME":
        {
          //statements;
          return Colors.green;
        }

      case "CANCELLED":
        {
          //statements;
          return Colors.redAccent;
        }
        break;

      default:
        {
          //statements;
          return Colors.black26;
        }
        break;
    }

    return Colors.red;
  }

  String getTerminal() {
    if (terminal == null) {
      return "-";
    } else {
      return terminal;
    }
  }
}
