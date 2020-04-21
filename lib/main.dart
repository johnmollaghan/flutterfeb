import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:flutterfeb/AirportPickerPage.dart';
import 'package:flutterfeb/AirportPickerPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart';

import 'Airport.dart';
import 'Globals.dart';
import 'FidsData.dart';
import 'FlightDetailsPage.dart';
import 'FlightSearchPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

SplayTreeMap airportHashMap = new SplayTreeMap<String, Airport>();
SplayTreeMap timeZoneHashmap = new SplayTreeMap<String, String>();

void main() => runApp(new MyApp());

/// Main App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData.dark(),
      home: new MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String flightType = "";
  String searchGate = "";
  String searchBag = "";
  String searchCity = "";
  String searchFlightNumber = "";
  String searchTerminal = "";
  bool isFiltered = false;

  /// Flights returned from api call
  Future<SplayTreeMap<String, FidsData>> myFlightFutureSortedMap;
  SplayTreeMap<String, FidsData> myFlightsSortedMap =
      new SplayTreeMap<String, FidsData>();

  /// Control state during loading
  var isLoading = true;

  /// Used to detect and report error
  bool isError = false;
  var errorString = "";

  String filterString = "";

  int currentTimeIndex = 0;
  var shouldGoToCurrentTime = true;

  int currentUserSelectedRow = 0;

  String currentAirportCode = "ORD";

  String currentFlightId = "";

  bool isProVersion;

  bool isAllAirports;

  String admobAppId = "";
  String admobBannerId = "";
  String admobInterstitialId = "";

  String currentLocale;

  String flight_date = "2020-03-18";
  static int flight_limit = 100;
  int flight_offset = 9 * flight_limit;

  /// First flight load
  _refreshFlights() {
    _updatePositions();

    /// Triggers progress spinner
    setState(() {
      isLoading = true;
    });

    print("Current row is = " + currentTimeIndex.toString());

    FidsData flight = myFlightsSortedMap.values.elementAt(currentTimeIndex);

    /// Call api
    setState(() {
      myFlightFutureSortedMap = _getFlights();
    });
  }

  void refreshArrivals() {
    flightType = Globals.ARRIVALS_CONST;
    shouldGoToCurrentTime = true;
    currentTimeIndex = 0;
    currentFlightId = "";
    saveFlightType();
    _refreshFlights();
  }



  void refreshDepartures() {
    flightType = Globals.DEPARTURES_CONST;
    shouldGoToCurrentTime = true;
    currentTimeIndex = 0;
    currentFlightId = "";
    saveFlightType();
    _refreshFlights();
  }

  /// Get airport list from embedded JSON asset file
  Future<bool> futureGetAirportList() async {
    String airportRawJSON = await DefaultAssetBundle.of(context)
        .loadString("assets/combined_airports.json");

    var airportJSONObjectList = json.decode(airportRawJSON);

    for (var airportJSONObj in airportJSONObjectList) {
      Airport airport = new Airport(
          airportJSONObj["fs"],
          airportJSONObj["name"],
          airportJSONObj["city"],
          airportJSONObj["countryCode"],
          airportJSONObj["timeZoneRegionName"],
          airportJSONObj["latitude"],
          airportJSONObj["longitude"],
          airportJSONObj["name_ar"],
          airportJSONObj["city_ar"],
          airportJSONObj["name_de"],
          airportJSONObj["city_de"],
          airportJSONObj["name_es"],
          airportJSONObj["city_es"],
          airportJSONObj["name_fr"],
          airportJSONObj["city_fr"],
          airportJSONObj["name_ja"],
          airportJSONObj["city_ja"],
          airportJSONObj["name_ko"],
          airportJSONObj["city_ko"],
          airportJSONObj["name_pt"],
          airportJSONObj["city_pt"],
          airportJSONObj["name_zh"],
          airportJSONObj["city_zh"]
      );

      airportHashMap[airportJSONObj["fs"]] = airport;

      timeZoneHashmap[airportJSONObj["timeZoneRegionName"]] =
          airportJSONObj["timeZoneRegionName"];
    }

    setState(() {
      myFlightFutureSortedMap = _getFlights();
    });

    return true;
  }

  @override
  void dispose() {
    // _itemPositionListener.itemPositions.removeListener(_updatePositions);
    super.dispose();
  }

  void _updatePositions() {
    if (_itemPositionListener.itemPositions.value.length > 0) {
      int lowestIndex = 1000000;

      for (var index in _itemPositionListener.itemPositions.value) {
        if (index.index <= lowestIndex) {
          lowestIndex = index.index;
        }
      }

      currentFlightId =
          myFlightsSortedMap.values.elementAt(lowestIndex).getFlightNumber();
    }
  }

  void setupTimezones() async {
    var byteData = await rootBundle.load('packages/timezone/data/2019c.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  @override
  void initState() {
    super.initState();

    isProVersion = false;
    isAllAirports = true;
    admobAppId = "";
    admobBannerId = "";
    admobInterstitialId = "";
    currentLocale = "";

    //  Locale myLocale = Localizations.localeOf(context);

    // var localDateTime = "";

    initializeTimeZones();

    //  _itemPositionListener.itemPositions.addListener(_updatePositions);

    restoreSearchConditions();
    futureGetAirportList();
  }

  /// Get information from Shared Preferences
  restoreSearchConditions() async {
    final prefs = await SharedPreferences.getInstance();

    this.flightType = prefs.getString('flightType') ?? Globals.ARRIVALS_CONST;
    this.searchGate = prefs.getString('searchGate') ?? "";
    this.searchBag = prefs.getString('searchBag') ?? "";
    this.searchCity = prefs.getString('searchCity') ?? "";
    this.searchFlightNumber = prefs.getString('searchFlightNumber') ?? "";
    this.searchTerminal = prefs.getString('searchTerminal') ?? "";

    this.isFiltered = searchGate.length > 0 ||
        searchBag.length > 0 ||
        searchCity.length > 0 ||
        searchFlightNumber.length > 0 ||
        searchTerminal.length > 0;

    if (this.isFiltered) {
      this.filterString = "Retriving Filtered Flights:";
      if (searchFlightNumber.length > 0) {
        this.filterString +=
            "Flight number contains: \n\n'" + searchFlightNumber + "'";
      }

      if (searchCity.length > 0) {
        this.filterString += "City contains: '" + searchCity + "'";
      }

      if (searchTerminal.length > 0) {
        this.filterString += "\n\nTerminal contains: '" + searchTerminal + "'";
      }

      if (searchGate.length > 0) {
        this.filterString += "\n\nGate contains: '" + searchGate + "'";
      }

      if (searchBag.length > 0) {
        this.filterString += "\n\nBaggage contains: '" + searchBag + "'";
      }
    } else {
      this.filterString = "\n\nRetrieving ALL Flights";
    }
  }

  saveFlightType() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('flightType', this.flightType.trim().toLowerCase());
  }

  String getCityFromCode(String code) {
    if (airportHashMap.containsKey(code)) {
      return airportHashMap[code].city;
    }
    else {
      return code;
    }
  }

  Future<SplayTreeMap<String, FidsData>> _getFlights() async {
    var data;
    myFlightsSortedMap.clear();
    try {
      var queryUrl =
          "https://www.momentsvideos.com/horseboxsoftware/development/scriptflutter_aviation_stack38394837465.php?pword1=10h228qPZ33728k73A&airportcodeval=" +
              currentAirportCode +
              "&listtypeval=" +
              flightType +
              "&flight_date=" +
              flight_date +
              "&flight_offset=" + flight_offset.toString() +
      "&flight_limit=" + flight_limit.toString();

      data = await http.get(queryUrl);
      isError = false;
      errorString = "";
      isLoading = false;

      var jsonData = json.decode(data.body);

      Airport airport = airportHashMap[currentAirportCode];
      Location airportLocation = getLocation(airport.timeZoneRegionName);
      final localCurrentDatetime = new TZDateTime.now(airportLocation);

      for (var flightListJSON in jsonData["data"]) {
        var arrivalJSON = flightListJSON["arrival"];
        var departureJSON = flightListJSON["departure"];
        var flightJSON = flightListJSON["flight"];
        var aircraftJSON = flightListJSON["aircraft"];
        var liveJSON = flightListJSON["live"];
        var codeShared = flightListJSON["codeShared"];
        var airlineJSON = flightListJSON["airline"];

        var flightNumber = flightJSON["iata"];

        var timeString = Globals.getTimeFromString(arrivalJSON["scheduled"]);

        if (timeString == "") {
          continue;
        }

        timeString = Globals.getTimeFromString(departureJSON["scheduled"]);

        if (timeString == "") {
          continue;
        }

        FidsData flight = FidsData(
            airlineJSON["iata"],
            airlineJSON["name"],
            arrivalJSON["actual_runway"],
            arrivalJSON["actual"],
            arrivalJSON["baggage"],
            arrivalJSON["delay"],
            arrivalJSON["estimated_runway"],
            arrivalJSON["estimated"],
            arrivalJSON["gate"],
            arrivalJSON["iata"],
            arrivalJSON["scheduled"],
            arrivalJSON["terminal"],
            departureJSON["actual_runway"],
            departureJSON["actual"],
            departureJSON["baggage"],
            departureJSON["delay"],
            departureJSON["estimated_runway"],
            departureJSON["estimated"],
            departureJSON["gate"],
            departureJSON["iata"],
            departureJSON["scheduled"],
            departureJSON["terminal"],
            flightJSON["iata"],
            flightListJSON["flight_status"],
            flightType,
            getCityFromCode(arrivalJSON["iata"]),
            getCityFromCode(departureJSON["iata"]),

        );

        if (searchTerminal.length > 0 &&
            (flight.getTerminal().toLowerCase()).contains(searchTerminal) ==
                false) {
          continue;
        }

        if (searchFlightNumber.length > 0 &&
            (flight.getFlightNumber().toLowerCase())
                    .toString()
                    .contains(searchFlightNumber) ==
                false) {
          continue;
        }

        if (searchCity.length > 0) {
          if (flightType == Globals.ARRIVALS_CONST) {
            if (flight.getOriginCity().toLowerCase().contains(searchCity) ==
                false) {
              continue;
            }
          } else {
            if (flight
                    .getDestinationCity()
                    .toLowerCase()
                    .contains(searchCity) ==
                false) {
              continue;
            }
          }
        }

        if (searchBag.length > 0 &&
            (flight.getBaggage().toLowerCase()).contains(searchBag) == false) {
          continue;
        }

        if (searchGate.length > 0 &&
            (flight.getGate().toLowerCase()).contains(searchGate) == false) {
          continue;
        }

        // Sort by time

        var uniqueKey = flight.getUniqueKey();
        if (myFlightsSortedMap.containsKey(uniqueKey)) {
          myFlightsSortedMap[uniqueKey].addCodeShare(flight.getFlightNumber());
        } else {
          myFlightsSortedMap[uniqueKey] = flight;
        }
      }

      // Find current time
      var addedIndex = 0;
      for (var flight in myFlightsSortedMap.values) {
        if (shouldGoToCurrentTime) {
          if (isBeyondCurrentTime(
              flight, localCurrentDatetime, airportLocation)) {
            currentTimeIndex = addedIndex;
            currentFlightId = flight.getFlightNumber();
            shouldGoToCurrentTime = false;
          }
        } else {
          if (flight.getFlightNumber() == currentFlightId) {
            currentTimeIndex = addedIndex;
          }
        }
        addedIndex++;
      }
    } catch (exception) {
      isLoading = false;
      isError = true;
      errorString = exception.toString();
      errorString = errorString.replaceAll("momentsvideos", "**");
    }

    return myFlightsSortedMap;
  }

  final ItemPositionsListener _itemPositionListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    bool _darkMode = false;
    bool _militaryTime = false;

    return new Scaffold(
      appBar: AppBar(title: Text("Flight Information - " + this.flightType)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        elevation: 4.0,
        icon: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        label: const Text(
          'Reload',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (!isLoading) {
            print("Reload Button Pressed");
            _refreshFlights();
          } else {
            null;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: isAllAirports,
              child: IconButton(
                icon: Icon(Icons.flight),
                onPressed: () {
                  if (!isLoading) {
                    print("Airport Button Pressed");
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AirportPickerPage()));
                  } else {
                    null;
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.flight_land),
              onPressed: () {
                if (!isLoading) {
                  print("Arrivals Button Pressed");
                  refreshArrivals();
                } else {
                  null;
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.flight_takeoff),
              onPressed: () {
                if (!isLoading) {
                  print("Departures Button Pressed");
                  refreshDepartures();
                } else {
                  null;
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                if (!isLoading) {
                  print("Flight Search Button Pressed");
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlightSearchPage()),
                  );

                  if (result == "Search") {
                    shouldGoToCurrentTime = true;
                    currentTimeIndex = 0;
                    currentFlightId = "";
                    setState(() {
                      restoreSearchConditions();
                      _refreshFlights();
                    });
                  }
                } else {
                  null;
                }
              },
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Icon(
                    Icons.flight,
                    size: 80,
                  ),
                )),
            SwitchListTile(
              title: const Text('Compact Mode'),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {});
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            Divider(
              color: Colors.amber,
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  _darkMode = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('24 Hour Clock'),
              value: _militaryTime,
              onChanged: (bool value) {
                setState(() {
                  _militaryTime = value;
                });
              },
              secondary: const Icon(Icons.access_time),
            ),
            ListTile(
              leading: new Icon(Icons.flight_land),
              title: Text("Arrivals"),
            ),
            ListTile(
              leading: new Icon(Icons.flight_takeoff),
              title: Text("Departures"),
            ),
            Visibility(
              visible: isAllAirports,
              child: ListTile(
                leading: new Icon(Icons.flight),
                title: Text("Airports"),
              ),
            ),
            ListTile(
              leading: new Icon(Icons.map),
              title: Text("Indoor Map"),
            ),
            ListTile(
              leading: new Icon(Icons.email),
              title: Text("Contact Developer"),
            ),
            ListTile(
              leading: new Icon(Icons.share),
              title: Text("Share this App"),
            ),
            ListTile(
              leading: new Icon(Icons.rate_review),
              title: Text("Rate this App"),
            ),
          ],
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: myFlightFutureSortedMap,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("Query Completed...Error is...");

            if (isLoading == false && isError) {
              return Container(
                  child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Icon(
                        Icons.error_outline,
                        size: 80,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "There was an error...",
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(errorString),
                    ],
                  ),
                ),
              ));
            }

            if (isLoading == true) {
              return Container(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                    new SizedBox(
                      height: 30,
                    ),
                    new Text(this.filterString),
                  ],
                ),
              ));
            } else {
              return ScrollablePositionedList.builder(
                itemPositionsListener: _itemPositionListener,
                initialScrollIndex: currentTimeIndex,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: Text(Globals.getTimeFromString(snapshot
                              .data.values
                              .elementAt(index)
                              .getScheduledTime()) +
                          "\n" +
                          Globals.getDateFromString(snapshot.data.values
                              .elementAt(index)
                              .getScheduledTime())),
                      //  leading: Text(snapshot.data[index].scheduledTime),
                      title: Text(
                        snapshot.data.values.elementAt(index).getAirportCity() +
                            " " +
                            snapshot.data.values
                                .elementAt(index)
                                .getFlightstatus(),
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(snapshot.data.values
                          .elementAt(index)
                          .getAirportName()),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => FlightDetailsPage(
                                    snapshot.data.values.elementAt(index))));
                      },
                    ),
                  );

                  /*       return ListTile(
                    leading: Text(snapshot.data[index].originAirportCode),
                    title: Text(snapshot.data[index].originCity),
                    subtitle: Text(snapshot.data[index].originAirportName),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  FlightDetailsPage(snapshot.data[index])));



                    },
                  );
 */
                },
              );
            }
          },
        ),
      ),
    );
  }

  bool isBeyondCurrentTime(FidsData flight, TZDateTime localCurrentDateTime,
      Location airportLocation) {
    try {
      var truncatedstring =
          flight.getScheduledTime().toString().substring(0, 16);
      DateFormat format = new DateFormat("yyyy-MM-ddTHH:mm");
      DateTime flightTime = format.parse(truncatedstring);

      final localFlightTime = new TZDateTime(airportLocation, flightTime.year,
          flightTime.month, flightTime.day, flightTime.hour, flightTime.minute);

      if (localFlightTime.isAfter(localCurrentDateTime)) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      print("Problem Parsing Date: " +
          flight.getFlightNumber() +
          "  [" +
          flight.getScheduledTime() +
          "]");
      return false;
    }
  }
}

afterLoadMethod(BuildContext context) {
  print("OK, widet tree has been rebuilt");
}
