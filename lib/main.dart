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
  Future<List<FidsData>> myFlightsFuture;
  List<FidsData> myFlightsList;

  /// Control state during loading
  var isLoading = true;

  /// Used to detect and report error
  bool isError = false;
  var errorString = "";

  String filterString = "";

  int currentTimeIndex = 0;
  var shouldGoToCurrentTime = true;

  int currentUserSelectedRow = 0;

  String currentAirportCode = "DTW";

  String currentFlightNumber = "";

  /// First flight load
  _refreshFlights() {
    /// Triggers progress spinner
    setState(() {
      isLoading = true;
    });

    print("Current row is = " + currentTimeIndex.toString());

    FidsData flight = myFlightsList.elementAt(currentTimeIndex);

    print("Current Flight = " +
        flight.getOriginCity() +
        " " +
        flight.getDestinationCity());

    print("### before getflights");

    /// Call api
    setState(() {
      myFlightsFuture = _getFlights();
    });

    print("### after getflights");
  }

  void refreshArrivals() {
    flightType = "arrivals";
    shouldGoToCurrentTime = true;
    currentTimeIndex = 0;
    currentFlightNumber = "";
    saveFlightType();
    _refreshFlights();
  }

  void refreshDepartures() {
    flightType = "departures";
    shouldGoToCurrentTime = true;
    currentTimeIndex = 0;
    currentFlightNumber = "";
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
          airportJSONObj["city_zh"]);

      airportHashMap[airportJSONObj["fs"]] = airport;

      timeZoneHashmap[airportJSONObj["timeZoneRegionName"]] =
          airportJSONObj["timeZoneRegionName"];
    }

    setState(() {
      myFlightsFuture = _getFlights();
    });

    return true;
  }

  @override
  void dispose() {
    _itemPositionListener.itemPositions.removeListener(_updatePositions);
    super.dispose();
  }

  void _updatePositions() {
    if (_itemPositionListener.itemPositions.value.length > 0) {
      currentFlightNumber = myFlightsList[_itemPositionListener.itemPositions.value.first.index].getFlightNumber();
    }
  }

  void setupTimezones() async {
    var byteData = await rootBundle.load('packages/timezone/data/2019c.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  @override
  void initState() {
    super.initState();


    var localDateTime = "";

    initializeTimeZones();

      _itemPositionListener.itemPositions.addListener(_updatePositions);

      restoreSearchConditions();
      futureGetAirportList();


  }

  /// Get information from Shared Preferences
  restoreSearchConditions() async {
    final prefs = await SharedPreferences.getInstance();

    this.flightType = prefs.getString('flightType') ?? "arrivals";
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

  Future<List<FidsData>> _getFlights() async {
    var data;
    myFlightsList = [];
    try {
      var queryUrl =
          "https://www.momentsvideos.com/horseboxsoftware/development/scriptandroid6943857410.php?pword1=10h228qPZ33728k73A&pword2=44f3384u79384tWE28y8&secret_code=HalloweenIsDone&manufacturer=samsung&model=SM-A505FN&brand=samsung&os_version=28&pword3=qtt454ud133397&pword99=164468974719&pword5=339iuy9879disu33987shfjjehg382768&pword4=a4d808f6-b261-49a2-8cae-4976fd617825&airportcodeval=" + currentAirportCode + "&airportcity=Please+check+your+device%27s+memory.&airportcountrycode=GB&airportcountryname=Error&platform=android&timestamp=1582234323176&geonames_id=none&appversion=5.0.2.1&listtypeval=";

      data = await http.get(queryUrl + flightType + "&all_param=false");
      isError = false;
      errorString = "";
      isLoading = false;

      var jsonData = json.decode(data.body);

      var addedIndex = 0;

      Airport airport = airportHashMap[currentAirportCode];
      Location airportLocation = getLocation(airport.timeZoneRegionName);
      final localCurrentDatetime = new TZDateTime.now(airportLocation);

      for (var flightJSON in jsonData["fidsData"]) {
        if (isFiltered) {
          if (searchTerminal.length > 0 &&
              (flightJSON["terminal"].toString().toLowerCase())
                      .contains(searchTerminal) ==
                  false) {
            continue;
          }

          if (searchFlightNumber.length > 0 &&
              (flightJSON["airlineCode"].toString().toLowerCase() +
                          flightJSON["flightNumber"].toString().toLowerCase())
                      .toString()
                      .contains(searchFlightNumber) ==
                  false) {
            continue;
          }

          if (searchCity.length > 0) {
            if (flightType == "arrivals") {
              if (flightJSON["originCity"]
                      .toString()
                      .toLowerCase()
                      .contains(searchCity) ==
                  false) {
                continue;
              }
            } else {
              if (flightJSON["destinationCity"]
                      .toString()
                      .toLowerCase()
                      .contains(searchCity) ==
                  false) {
                continue;
              }
            }
          }

          if (searchBag.length > 0 &&
              (flightJSON["baggage"].toString().toLowerCase())
                      .contains(searchBag) ==
                  false) {
            continue;
          }

          if (searchGate.length > 0 &&
              (flightJSON["gate"].toString().toLowerCase())
                      .contains(searchGate) ==
                  false) {
            continue;
          }
        }

        FidsData flight = FidsData(
            flightJSON["flightId"],
            flightJSON["statusCode"],
            flightJSON["gate"],
            flightJSON["terminal"],
            flightJSON["baggage"],
            flightJSON["airlineName"],
            flightJSON["airlineCode"],
            flightJSON["flightNumber"],
            flightJSON["originAirportName"],
            flightJSON["originAirportCode"],
            flightJSON["originCity"],
            flightJSON["originCountryCode"],
            flightJSON["destinationAirportName"],
            flightJSON["destinationAirportCode"],
            flightJSON["destinationCity"],
            flightJSON["destinationCountryCode"],
            flightJSON["delayed"],
            flightJSON["remarksWithTime"],
            flightJSON["remarksCode"],
            flightJSON["scheduledTime"],
            flightJSON["scheduledDate"],
            flightJSON["estimatedTime"],
            flightJSON["estimatedDate"],
            flightJSON["actualTime"],
            flightJSON["actualDate"]);

        myFlightsList.add(flight);

        if (shouldGoToCurrentTime) {
          if (isBeyondCurrentTime(flight, localCurrentDatetime, airportLocation)) {
            currentTimeIndex = addedIndex;
            currentFlightNumber = flight.getFlightNumber();
            shouldGoToCurrentTime = false;
          }
        }
        else {
          if (flight.getFlightNumber() == currentFlightNumber) {
            currentTimeIndex = addedIndex;
          }
        }
        addedIndex++;
      }

      print("Number of Flights = ");
      print(myFlightsList.length);
    } catch (exception) {
      isLoading = false;
      isError = true;
      errorString = exception.toString();
      errorString = errorString.replaceAll("momentsvideos", "**");
    }

    return myFlightsList;
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
            IconButton(
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
                    currentFlightNumber = "";
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
            ListTile(
              leading: new Icon(Icons.flight),
              title: Text("Airports"),
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
          future: myFlightsFuture,
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
                      leading: Text(snapshot.data[index].getScheduledTime() +
                          "\n" +
                          snapshot.data[index].getScheduledDate()),
                      //  leading: Text(snapshot.data[index].scheduledTime),
                      title: Text(
                        //  airportList[snapshot.data[index].getAirportCode(flightType)].city_zh ,

                        snapshot.data[index].getAirportCity(flightType),
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                          snapshot.data[index].getAirportName(flightType) +
                              "\n" +
                              snapshot.data[index].getRemarksWithTime() +
                              " - " +
                              snapshot.data[index].getStatusCode() +
                              " - " +
                              "bag " +
                              snapshot.data[index].getBaggage() +
                              " - " +
                              "gate " +
                              snapshot.data[index].getGate() +
                              " - " +
                              snapshot.data[index].getAirlineCode() +
                              " - " +
                              snapshot.data[index].getRemarksCode()),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    FlightDetailsPage(snapshot.data[index])));
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

  bool isBeyondCurrentTime(FidsData flight, TZDateTime localCurrentDateTime, Location airportLocation) {

    DateFormat format = new DateFormat("MM/dd/yyyy HH:mm");
    DateTime flightTime = format.parse(flight.getScheduledDate() + " " + flight.getScheduledTime());

    final localFlightTime = new TZDateTime(airportLocation, flightTime.year, flightTime.month, flightTime.day, flightTime.hour, flightTime.minute);

    if (localFlightTime.isAfter(localCurrentDateTime)) {
      return true;
    }
    else {
      return false;
    }

  }
}

afterLoadMethod(BuildContext context) {
  print("OK, widet tree has been rebuilt");
}
