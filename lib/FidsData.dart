import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "main.dart";

class FidsData {
  String _flightId;
  String _statusCode;
  String _gate;
  String _terminal;
  String _baggage;
  String _airlineName;
  String _airlineCode;
  String _flightNumber;
  String _originAirportName;
  String _originAirportCode;
  String _originCity;
  String _originCountryCode;
  String _destinationAirportName;
  String _destinationAirportCode;
  String _destinationCity;
  String _destinationCountryCode;
  bool _delayed;
  String _remarksWithTime;
  String _remarksCode;
  String _scheduledTime;
  String _scheduledDate;
  String _estimatedTime;
  String _estimatedDate;
  String _actualTime;
  String _actualDate;
  List<String> _codesharesAsNames;
  List<String> _codesharesAsCodes;

  FidsData(
      this._flightId,
      this._statusCode,
      this._gate,
      this._terminal,
      this._baggage,
      this._airlineName,
      this._airlineCode,
      this._flightNumber,
      this._originAirportName,
      this._originAirportCode,
      this._originCity,
      this._originCountryCode,
      this._destinationAirportName,
      this._destinationAirportCode,
      this._destinationCity,
      this._destinationCountryCode,
      this._delayed,
      this._remarksWithTime,
      this._remarksCode,
      this._scheduledTime,
      this._scheduledDate,
      this._estimatedTime,
      this._estimatedDate,
      this._actualTime,
      this._actualDate
      /*this.codesharesAsNames,
      this.codesharesAsCodes
      */
      );

  String getActualDate() {
    if (_actualDate == null) {
      return "-";
    } else {
      return _actualDate;
    }
  }
  String getRemarksCode() {
    if (_remarksCode == null) {
      return "-";
    } else {
      return _remarksCode;
    }
  }

  String getOriginCity() {
    if (_originCity == null) {
      return "-";
    } else {
      return _originCity;
    }
  }

  String getAirlineName() {
    if (_airlineName == null) {
      return "-";
    } else {
      return _airlineName;
    }
  }

  String getOriginAirportName() {
    if (_originAirportName == null) {
      return "-";
    } else {
      return _originAirportName;
    }
  }

  String getOriginAirportCode() {
    if (_originAirportCode == null) {
      return "-";
    } else {
      return _originAirportCode;
    }
  }

  String getDestinationCity() {
    if (_destinationCity == null) {
      return "-";
    } else {
      return _destinationCity;
    }
  }

  String getDestinationAirportName() {
    if (_destinationAirportName == null) {
      return "-";
    } else {
      return _destinationAirportName;
    }
  }

  String getDestinationAirportCode() {
    if (_destinationAirportCode == null) {
      return "-";
    } else {
      return _destinationAirportCode;
    }
  }

  String getRemarksWithTime() {
    if (_remarksWithTime == null) {
      return "-";
    } else {
      return _remarksWithTime;
    }
  }

  String getStatusCode() {
    if (_statusCode == null) {
      return "-";
    } else {
      return _statusCode;
    }
  }
  
  
  String getAirlineCode() {
    if (_airlineCode == null) {
      return "-";
    } else {
      return _airlineCode;
    }
  }
  String getFlightId() {
    if (_flightId == null) {
      return "-";
    } else {
      return _flightId;
    }
  }

  String getFlightNumber() {
    if (_flightNumber == null) {
      return "-";
    } else {
      return _flightNumber;
    }
  }
  

  String getActualTime() {
    if (_actualTime == null) {
      return "-";
    } else {
      return _actualTime;
    }
  }

  String getAirportCode(String flightType) {
    if (flightType == "arrivals") {
      return _originAirportCode;
    } else {
      return _destinationAirportCode;
    }
  }

  String getAirportCity(String flightType) {
    if (flightType == "arrivals") {
      return _originCity;
    } else {
      return _destinationCity;
    }
  }

  String getAirportName(String flightType) {
    if (flightType == "arrivals") {
      return _originAirportName;
    } else {
      return _destinationAirportName;
    }
  }

  String getBaggage() {
    if (_baggage == null) {
      return "-";
    } else {
      return _baggage;
    }
  }

  String getEstimatedDate() {
    if (_estimatedDate == null) {
      return "-";
    } else {
      return _estimatedDate;
    }
  }

  String getEstimatedTime() {
    if (_estimatedTime == null) {
      return "-";
    } else {
      return _estimatedTime;
    }
  }

  String getGate() {
    if (_gate == null) {
      return "-";
    } else {
      return _gate;
    }
  }

  String getScheduledDate() {
    if (_scheduledDate == null) {
      return "-";
    } else {
      return _scheduledDate;
    }
  }

  String getScheduledTime() {
    if (_scheduledTime == null) {
      return "-";
    } else {
      return _scheduledTime;
    }
  }

  Color getStatusColor() {
    switch (_remarksCode) {
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
    if (_terminal == null) {
      return "-";
    } else {
      return _terminal;
    }
  }
}
