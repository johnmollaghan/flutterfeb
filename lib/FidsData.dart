import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "main.dart";
import 'Globals.dart';

class FidsData {
  // Airline

  String _airlineCode = "";
  String _airlineName = "";

  // Arrival
  String _arrivalActualRunway = "";
  String _arrivalActualTime = "";
  String _arrivalBaggage = "";
  int _arrivalDelay = 0;
  String _arrivalEstimatedRunway = "";
  String _arrivalEstimatedTime = "";
  String _arrivalGate = "";
  String _arrivalAirportCode = "";
  String _arrivalScheduledTime = "";
  String _arrivalTerminal = "";
  String _arrivalCity = "";

  List<String> _codeShares = new List<String>();

  // Departure
  String _departureActualRunway = "";
  String _departureActualTime = "";
  String _departureBaggage = "";
  int _departureDelay = 0;
  String _departureEstimatedRunway = "";
  String _departureEstimatedTime = "";
  String _departureGate = "";
  String _departureAirportCode = "";
  String _departureScheduledTime = "";
  String _departureTerminal = "";
  String _departureCity = "";


  String _flightNumber = "";
  String _flightStatus = "";
  String _flightType = "";

  FidsData(
      this._airlineCode,
      this._airlineName,
      this._arrivalActualRunway,
      this._arrivalActualTime,
      this._arrivalBaggage,
      this._arrivalDelay,
      this._arrivalEstimatedRunway,
      this._arrivalEstimatedTime,
      this._arrivalGate,
      this._arrivalAirportCode,
      this._arrivalScheduledTime,
      this._arrivalTerminal,
      this._departureActualRunway,
      this._departureActualTime,
      this._departureBaggage,
      this._departureDelay,
      this._departureEstimatedRunway,
      this._departureEstimatedTime,
      this._departureGate,
      this._departureAirportCode,
      this._departureScheduledTime,
      this._departureTerminal,
      this._flightNumber,
      this._flightStatus,
      this._flightType,
      this._arrivalCity,
      this._departureCity


      );

  Color getStatusColor() {

    switch (_flightStatus) {
      case "scheduled": return Colors.indigo;
      case "active": return Colors.indigo;
      case "cancelled": return Colors.redAccent;
      case "landed": return Colors.green;
      default: Colors.grey;
    }

  }

  addCodeShare(String codeShare) {
    _codeShares.add(codeShare);
  }

  List<String> getCodeShares() {
    return _codeShares;
  }

  String getScheduledTime() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalScheduledTime;
    } else {
      returnVal = _departureScheduledTime;
    }
    if (returnVal == null) {
      returnVal = "-";
    }

    return returnVal;
  }

  String getFlightNumber() {
    var returnVal = _flightNumber;
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getArrivalCity() {
    var returnVal = _arrivalCity;
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getDepartureCity() {
    var returnVal = _departureCity;
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getFlightstatus() {
    var returnVal = _flightStatus;
    if (returnVal == null) {
      returnVal = "-";
    }

    return returnVal;
  }

  String getAirlineCode() {
    var returnVal = _airlineCode;
    if (returnVal == null) {
      returnVal = "-";
    }

    return returnVal;
  }

  String getAirlineName() {
    var returnVal = _airlineName;
    if (returnVal == null) {
      returnVal = "-";
    }

    return returnVal;
  }



  String getCity() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _departureCity;
    } else {returnVal = _arrivalCity;
    }
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  int getDelay() {
    var returnVal = 0;
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalDelay;
    } else {
      returnVal = _departureDelay;
    }
    if (returnVal == null) {
      returnVal = 0;
    }
    return returnVal;
  }

  String getTerminal() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalTerminal;
    } else {
      returnVal = _departureTerminal;
    }
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getArrivalAirportCode() {
    var returnVal = "";

    returnVal = _arrivalAirportCode;

    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getDepartureAirportCode() {
    var returnVal = "";

    returnVal = _departureAirportCode;

    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getAirportCode() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _departureAirportCode;
    } else {
      returnVal = _arrivalAirportCode;
    }
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getAirportName() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _departureAirportCode;
    } else {
      returnVal = _arrivalAirportCode;
    }
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getAirportCity() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _departureAirportCode;
    } else {
      returnVal = _arrivalAirportCode;
    }
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getBaggage() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalBaggage;
    } else {
      returnVal = _departureBaggage;
    }
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getDepartureGate() {
    var returnVal = "";

    returnVal = _departureGate;

    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getDepartureTerminal() {
    var returnVal = "";

    returnVal = _departureTerminal;

    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getDepartureBaggage() {
    var returnVal = "";

    returnVal = _departureBaggage;

    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  int getDepartureDelay() {
    var returnVal = 0;

    returnVal = _departureDelay;

    if (returnVal == null) {
      returnVal = 0;
    }
    return returnVal;
  }

  String getArrivalGate() {
    var returnVal = "";

    returnVal = _arrivalGate;

    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getArrivalTerminal() {
    var returnVal = "";

    returnVal = _arrivalTerminal;

    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getArrivalBaggage() {
    var returnVal = "";

    returnVal = _arrivalBaggage;

    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getUniqueKey() {
    if (_flightType == Globals.ARRIVALS_CONST) {
      return _arrivalScheduledTime + _departureAirportCode + getArrivalTerminal() + getArrivalGate() + getArrivalBaggage();
    }
    else {
      return _departureScheduledTime + _arrivalAirportCode + getDepartureTerminal() + getDepartureGate() + getDepartureBaggage();
    }
  }

  int getArrivalDelay() {
    var returnVal = 0;

    returnVal = _arrivalDelay;

    if (returnVal == null) {
      returnVal = 0;
    }
    return returnVal;
  }

  String getGate() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalGate;
    } else {
      returnVal = _departureGate;
    }
    if (returnVal == null) {
      returnVal = "-";
    }
    return returnVal;
  }

  String getArrivalScheduledTime() {
    if (_arrivalScheduledTime != null) {
      return _arrivalScheduledTime;
    }
    return "-";
  }

  String getDepartureScheduledTime() {
    if (_departureScheduledTime != null) {
      return _departureScheduledTime;
    }
    return "-";
  }

  String getArrivalActualTime() {
    var returnVal = "";

    if (_arrivalActualTime != null) {
      return _arrivalActualTime;
    }
    if (_arrivalActualRunway != null) {
      return _arrivalActualRunway;
    }
    return "-";
  }

  String getArrivalEstimatedTime() {
    if (_arrivalEstimatedTime != null) {
      return _arrivalEstimatedTime;
    }
    if (_arrivalEstimatedRunway != null) {
      return _arrivalEstimatedRunway;
    }
    return "-";
  }

  String getDepartureEstimatedTime() {
    if (_departureEstimatedTime != null) {
      return _departureEstimatedTime;
    }
    if (_departureEstimatedRunway != null) {
      return _departureEstimatedRunway;
    }
    return "-";
  }

  String getDepartureActualTime() {
    var returnVal = "";

    if (_departureActualTime != null) {
      return _departureActualTime;
    }
    if (_departureActualRunway != null) {
      return _departureActualRunway;
    }
    return "-";
  }

  String getActualTime() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalActualTime;
    } else {
      returnVal = _departureActualTime;
    }
    if (returnVal == null) {
      returnVal = "-";
    }

    return returnVal;
  }

  String getEstimatedTime() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalEstimatedTime;
    } else {
      returnVal = _departureEstimatedTime;
    }
    if (returnVal == null) {
      returnVal = "-";
    }

    return returnVal;
  }

  String getActualRunway() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalActualRunway;
    } else {
      returnVal = _departureActualRunway;
    }
    if (returnVal == null) {
      returnVal = "-";
    }

    return returnVal;
  }

  String getEstimatedRunway() {
    var returnVal = "";
    if (_flightType.toLowerCase() == Globals.ARRIVALS_CONST) {
      returnVal = _arrivalEstimatedRunway;
    } else {
      returnVal = _departureEstimatedRunway;
    }
    if (returnVal == null) {
      returnVal = "-";
    }

    return returnVal;
  }

  String getOriginCity() { return _departureAirportCode;}

  String getDestinationCity() {return _arrivalAirportCode;}
}
