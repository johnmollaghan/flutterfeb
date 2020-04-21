import 'package:intl/intl.dart';

class Globals {
  static String ARRIVALS_CONST = "arrival";
  static String DEPARTURES_CONST = "departure";

  static String getTimeFromString(dateString) {
    try {
      var truncatedstring = dateString.toString().substring(0, 16);
      DateFormat format = new DateFormat("yyyy-MM-ddTHH:mm");
      DateTime flightTime = format.parse(truncatedstring);
      return flightTime.hour.toString() + ":" + flightTime.minute.toString();
    }
    catch (exception) {
      return "";
    }
  }

  static String getDateFromString(dateString) {
    try {
      var truncatedstring = dateString.toString().substring(0, 16);
      DateFormat format = new DateFormat("yyyy-MM-ddTHH:mm");
      DateTime flightTime = format.parse(truncatedstring);

      return getWeekdayString(flightTime.weekday) + " " +
          flightTime.day.toString();
    }
    catch (exception) {
      return "";
    }
  }

  static String getWeekdayString(dayNumber) {
    switch (dayNumber) {

      case 1: return "Monday";
      case 2: return "Tuesday";
      case 3: return "Wednesday";
      case 4: return "Thursday";
      case 5: return "Friday";
      case 6: return "Saturday";
      case 7: return "Sunday";
      default: return "Unknown Day";

    }
  }
}
