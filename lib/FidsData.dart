class FidsData {
  String flightId;
  String statusCode;
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
}