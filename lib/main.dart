import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutterfeb/AirportPickerPage.dart';
import 'package:http/http.dart' as http;

import 'Airport.dart';
import 'FidsData.dart';
import 'FlightDetailsPage.dart';
import 'FlightSearchPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

SplayTreeMap airportList = new SplayTreeMap<String, Airport>();

void main() => runApp(new MyApp());

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
  String flightType = "arrivals";

  String searchGate;
  String searchBag;
  String searchCity;
  String searchFlightNumber;
  String searchTerminal;
  bool isFiltered = false;

  var launchTime;

  Future<List<FidsData>> myFlights;

  var isLoading = true;

  bool isError = false;
  var errorString = "";

  void _refreshFlights() {
    setState(() {
      isLoading = true;
    });

    setState(() {
      myFlights = _getFlights();
    });
  }

  void refreshArrivals() {
    flightType = "arrivals";
    _refreshFlights();
  }

  void refreshDepartures() {
    flightType = "departures";
    _refreshFlights();
  }

  Future<String> futureGetAirportList() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/combined_airports.json");

    var jsonData = json.decode(data);

    int x = 0;
    for (var i in jsonData) {
      Airport airport = new Airport(
          i["fs"],
          i["name"],
          i["city"],
          i["countryCode"],
          i["timeZoneRegionName"],
          i["latitude"],
          i["longitude"],
          i["name_ar"],
          i["city_ar"],
          i["name_de"],
          i["city_de"],
          i["name_es"],
          i["city_es"],
          i["name_fr"],
          i["city_fr"],
          i["name_ja"],
          i["city_ja"],
          i["name_ko"],
          i["city_ko"],
          i["name_pt"],
          i["city_pt"],
          i["name_zh"],
          i["city_zh"]);

      airportList[i["fs"]] = airport;
    }

    setState(() {
      myFlights = _getFlights();
    });

    // final jsonResult = json.decode(data);

    return data.substring(0, 50);
  }

  @override
  void initState() {
    super.initState();

    restoreSearchConditions();

    launchTime = new DateTime.now().millisecondsSinceEpoch;

    //   var result = Future.wait(loadAsset());

    var futures = List<Future>();

    futureGetAirportList();
  }

  restoreSearchConditions() async {
    print("### Restore Search Conditions");
    final prefs = await SharedPreferences.getInstance();

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
  }

  Future<List<FidsData>> _getFlights() async {
    //  var data = await http
    //    .get("http://www.json-generator.com/api/json/get/caGPKvQpaq?indent=2");

    var data;
    List<FidsData> flightsList = [];
    try {
      print("REFRESHING LIST");

      var queryUrl =
          "https://www.momentsvideos.com/horseboxsoftware/development/scriptandroid6943857410.php?pword1=10h228qPZ33728k73A&pword2=44f3384u79384tWE28y8&secret_code=HalloweenIsDone&manufacturer=samsung&model=SM-A505FN&brand=samsung&os_version=28&pword3=qtt454ud133397&pword99=164468974719&pword5=339iuy9879disu33987shfjjehg382768&pword4=a4d808f6-b261-49a2-8cae-4976fd617825&airportcodeval=CDG&airportcity=Please+check+your+device%27s+memory.&airportcountrycode=GB&airportcountryname=Error&platform=android&timestamp=1582234323176&geonames_id=none&appversion=5.0.2.1&listtypeval=";

      data = await http.get(queryUrl + flightType + "&all_param=false");
      isError = false;
      errorString = "";
      isLoading = false;

      //  https://www.momentsvideos.com/horseboxsoftware/development/scriptandroid6943857410.php?pword1=10h228qPZ33728k73A&pword2=44f3384u79384tWE28y8&secret_code=HalloweenIsDone&manufacturer=samsung&model=SM-A505FN&brand=samsung&os_version=28&pword3=qtt454ud133397&pword99=164468974719&pword5=339iuy9879disu33987shfjjehg382768&pword4=a4d808f6-b261-49a2-8cae-4976fd617825&airportcodeval=ORD&airportcity=Please+check+your+device%27s+memory.&airportcountrycode=GB&airportcountryname=Error&platform=android&timestamp=1582234323176&geonames_id=none&appversion=5.0.2.1&listtypeval=arrivals&all_param=false

      var jsonData = json.decode(data.body);

      var appList = jsonData["fidsData"];

      print('jsonData["applist"]');

      print("### Reloading, Filtered = " + isFiltered.toString());

      for (var i in jsonData["fidsData"]) {
        if (isFiltered) {
          if (searchTerminal.length > 0 &&
              (i["terminal"].toString().toLowerCase()).contains(searchTerminal) == false) {
            continue;
          }

          if (searchFlightNumber.length > 0 &&
              (i["airlineCode"].toString().toLowerCase() + i["flightNumber"].toString().toLowerCase()).toString().contains(searchFlightNumber) ==
                  false) {
            continue;
          }

          if (searchCity.length > 0) {
            if (flightType == "arrivals") {
              if (i["originCity"].toString().toLowerCase().contains(searchCity) == false) {
                continue;
              }
            } else {
              if (i["destinationCity"].toString().toLowerCase().contains(searchCity) == false) {
                continue;
              }
            }
          }

          if (searchBag.length > 0 &&
              (i["baggage"].toString().toLowerCase()).contains(searchBag) == false) {
            continue;
          }

          if (searchGate.length > 0 &&
              (i["gate"].toString().toLowerCase()).contains(searchGate) == false) {
            continue;
          }
        }

        FidsData flight = FidsData(
            i["flightId"],
            i["statusCode"],
            i["gate"],
            i["terminal"],
            i["baggage"],
            i["airlineName"],
            i["airlineCode"],
            i["flightNumber"],
            i["originAirportName"],
            i["originAirportCode"],
            i["originCity"],
            i["originCountryCode"],
            i["destinationAirportName"],
            i["destinationAirportCode"],
            i["destinationCity"],
            i["destinationCountryCode"],
            i["delayed"],
            i["remarksWithTime"],
            i["remarksCode"],
            i["scheduledTime"],
            i["scheduledDate"],
            i["estimatedTime"],
            i["estimatedDate"],
            i["actualTime"],
            i["actualDate"]);

        flightsList.add(flight);
      }

      print("Number of Flights = ");
      print(flightsList.length);
    } catch (exception) {
      isLoading = false;
      isError = true;
      errorString = exception.toString();
      errorString = errorString.replaceAll("momentsvideos", "**");
    }

    return flightsList;
  }

  @override
  Widget build(BuildContext context) {
    bool _darkMode = false;
    bool _militaryTime = false;

    return new Scaffold(
      appBar: AppBar(title: const Text("Flight Information")),
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
          future: myFlights,
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
                child: new CircularProgressIndicator(),
              ));
            } else {
              return ListView.builder(
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

                              "bag " + snapshot.data[index].getBaggage() +
                              " - " +

                              "gate " + snapshot.data[index].getGate() +
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
}
