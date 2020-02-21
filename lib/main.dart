import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  Future<List<FidsData>> _getUsers() async {
    //  var data = await http
    //    .get("http://www.json-generator.com/api/json/get/caGPKvQpaq?indent=2");

    var data;
    try {
      data = await http.get(
          "https://www.momentsvideos.com/horseboxsoftware/development/scriptandroid6943857410.php?pword1=10h228qPZ33728k73A&pword2=44f3384u79384tWE28y8&secret_code=HalloweenIsDone&manufacturer=samsung&model=SM-A505FN&brand=samsung&os_version=28&pword3=qtt454ud133397&pword99=164468974719&pword5=339iuy9879disu33987shfjjehg382768&pword4=a4d808f6-b261-49a2-8cae-4976fd617825&airportcodeval=ABZ&airportcity=Please+check+your+device%27s+memory.&airportcountrycode=GB&airportcountryname=Error&platform=android&timestamp=1582234323176&geonames_id=none&appversion=5.0.2.1&listtypeval=arrivals&all_param=false");
    } catch (_) {
      print('Error!!');
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("Query Completed...Error is...");
            print(snapshot.hasError);
            print(snapshot.error);
            print(snapshot.data);
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text(snapshot.data[index].originAirportCode),
                    title: Text(snapshot.data[index].originCity),
                    subtitle: Text(snapshot.data[index].originAirportName),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(snapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final FidsData flight;

  DetailPage(this.flight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(flight.remarksWithTime),
    ));
  }
}

class User {
  final int index;
  final String about;
  final String name;
  final String email;
  final String picture;

  User(this.index, this.about, this.name, this.email, this.picture);
}

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
