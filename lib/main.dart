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

  var launchTime;

  Future<List<FidsData>> myFlights;

  void _refreshFlights() {
    setState(() {
      myFlights = _getFlights();
    });
  }

  void refreshArrivals() {
    setState(() {
      flightType = "arrivals";
      _refreshFlights();
    });
  }

  void refreshDepartures() {
    setState(() {
      flightType = "departures";
      _refreshFlights();
    });
  }

  Future<String> futureGetAirportList() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/combined_airports.json");

    var jsonData = json.decode(data);

    int x = 0;
    for (var i in jsonData) {
      print("Adding Airport - " + i.toString());
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

      airportList[i["fs"]] =  airport;
    }

    print("JM_LOG - loadString completed");

    setState(() {
      myFlights = _getFlights();
    });

    // final jsonResult = json.decode(data);

    return data.substring(0, 50);
  }

  @override
  void initState() {
    super.initState();

    launchTime = new DateTime.now().millisecondsSinceEpoch;

    //   var result = Future.wait(loadAsset());

    var futures = List<Future>();

    futureGetAirportList();
  }

  Future<List<FidsData>> _getFlights() async {
    //  var data = await http
    //    .get("http://www.json-generator.com/api/json/get/caGPKvQpaq?indent=2");

    var data;
    try {
      print("REFRESHING LIST");
      data = await http.get(
          "https://www.momentsvideos.com/horseboxsoftware/development/scriptandroid6943857410.php?pword1=10h228qPZ33728k73A&pword2=44f3384u79384tWE28y8&secret_code=HalloweenIsDone&manufacturer=samsung&model=SM-A505FN&brand=samsung&os_version=28&pword3=qtt454ud133397&pword99=164468974719&pword5=339iuy9879disu33987shfjjehg382768&pword4=a4d808f6-b261-49a2-8cae-4976fd617825&airportcodeval=CDG&airportcity=Please+check+your+device%27s+memory.&airportcountrycode=GB&airportcountryname=Error&platform=android&timestamp=1582234323176&geonames_id=none&appversion=5.0.2.1&listtypeval=" +
              flightType +
              "&all_param=false");
    } catch (_) {
      final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }

    //  https://www.momentsvideos.com/horseboxsoftware/development/scriptandroid6943857410.php?pword1=10h228qPZ33728k73A&pword2=44f3384u79384tWE28y8&secret_code=HalloweenIsDone&manufacturer=samsung&model=SM-A505FN&brand=samsung&os_version=28&pword3=qtt454ud133397&pword99=164468974719&pword5=339iuy9879disu33987shfjjehg382768&pword4=a4d808f6-b261-49a2-8cae-4976fd617825&airportcodeval=ORD&airportcity=Please+check+your+device%27s+memory.&airportcountrycode=GB&airportcountryname=Error&platform=android&timestamp=1582234323176&geonames_id=none&appversion=5.0.2.1&listtypeval=arrivals&all_param=false

    var jsonData = json.decode(data.body);

    var appList = jsonData["fidsData"];

    print('jsonData["applist"]');

    List<FidsData> flightsList = [];

    for (var i in jsonData["fidsData"]) {
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
          _refreshFlights();
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
              icon: Icon(Icons.account_balance),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => AirportPickerPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.flight_land),
              onPressed: () {
                refreshArrivals();
              },
            ),
            IconButton(
              icon: Icon(Icons.flight_takeoff),
              onPressed: () {
                refreshDepartures();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => FlightSearchPage()));
              },
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
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
              title: Text("Contact Develop"),
            ),
          ],
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: myFlights,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("Query Completed...Error is...");
            if (snapshot.data == null) {
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
                      leading: Text(snapshot.data[index].scheduledTime +
                          "\n" +
                          snapshot.data[index].scheduledDate),
                      //  leading: Text(snapshot.data[index].scheduledTime),
                      title: Text(
                     //  airportList[snapshot.data[index].getAirportCode(flightType)].city_zh ,


                            snapshot.data[index].getAirportCity(flightType),
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(

                          snapshot.data[index].getAirportName(flightType) +
                              "\n" +
                              snapshot.data[index].remarksWithTime +
                              " - " +
                              snapshot.data[index].statusCode +
                              " - " +
                              snapshot.data[index].remarksCode),
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
