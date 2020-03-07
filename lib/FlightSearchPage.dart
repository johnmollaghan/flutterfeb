import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlightSearchPage extends StatefulWidget {
  FlightSearchPage();

  @override
  _FlightSearchPageState createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  String searchGate;
  String searchBag;
  String searchCity;
  String searchFlightNumber;
  String searchTerminal;

  TextEditingController textGateController = TextEditingController();
  TextEditingController textBagController = TextEditingController();
  TextEditingController textCityController = TextEditingController();
  TextEditingController textFlightNumberController = TextEditingController();
  TextEditingController textTerminalController = TextEditingController();


  clearSearchConditions() async {
    print("clearing search");
    final prefs = await SharedPreferences.getInstance();

    this.searchFlightNumber = "";
    this.searchGate = "";
    this.searchBag = "";
    this.searchCity= "";
    this.searchTerminal  ="";

// set value
    prefs.setString('searchGate', this.searchGate.trim().toLowerCase());
    prefs.setString('searchBag', this.searchBag.trim().toLowerCase());
    prefs.setString('searchCity', this.searchCity.trim().toLowerCase());
    prefs.setString('searchFlightNumber', this.searchFlightNumber.trim().toLowerCase().replaceAll(" ", ""));
    prefs.setString('searchTerminal', this.searchTerminal.trim().toLowerCase());
  }

  saveSearchConditions() async {
    print("saving settings");
    final prefs = await SharedPreferences.getInstance();

// set value
    prefs.setString('searchGate', this.searchGate.trim().toLowerCase());
    prefs.setString('searchBag', this.searchBag.trim().toLowerCase());
    prefs.setString('searchCity', this.searchCity.trim().toLowerCase());
    prefs.setString('searchFlightNumber', this.searchFlightNumber.trim().toLowerCase().replaceAll(" ", ""));
    prefs.setString('searchTerminal', this.searchTerminal.trim().toLowerCase());

    print("jm_log setting flight number to - " + this.searchFlightNumber);
  }

  restoreSearchConditions() async {
    print("restore");
    final prefs = await SharedPreferences.getInstance();

    this.searchGate = prefs.getString('searchGate') ?? "";
    this.searchBag = prefs.getString('searchBag') ?? "";
    this.searchCity = prefs.getString('searchCity') ?? "";
    this.searchFlightNumber = prefs.getString('searchFlightNumber') ?? "";
    this.searchTerminal = prefs.getString('searchTerminal') ?? "";

    textGateController.text = prefs.getString('searchGate') ?? "";
    textBagController.text = prefs.getString('searchBag') ?? "";
    textCityController.text = prefs.getString('searchCity') ?? "";
    textFlightNumberController.text =
        prefs.getString('searchFlightNumber') ?? "";
    textTerminalController.text = prefs.getString('searchTerminal') ?? "";

    print("Flight number = " + this.searchFlightNumber);
  }

  @override
  void initState() {
    super.initState();

    print("init state");
    setState(() {
      restoreSearchConditions();
    });
  }

  @override
  Widget build(BuildContext context) {

    bool isFilterEnabled = false;
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 24.0,
                  ),

                
                  TextFormField(
                    controller: textFlightNumberController,
                    decoration: InputDecoration(
                      labelText: "Flight Number",
                      icon: Icon(Icons.flight),
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: "e.g. FR123",
                    ),
                    onChanged: (String value) {
                      print("### on save flight number - " + value);
                      this.searchFlightNumber = value;
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    controller: textCityController,
                    decoration: InputDecoration(
                      labelText: "City",
                      icon: Icon(Icons.map),
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: "e.g. London",
                    ),
                    onChanged: (String value) {
                      this.searchCity = value;
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    controller: textTerminalController,
                    decoration: InputDecoration(
                      labelText: "Terminal",
                      icon: Icon(Icons.business),
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: "e.g. 1, 1A",
                    ),
                    onChanged: (String value) {
                      this.searchTerminal = value;
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    controller: textGateController,
                    decoration: InputDecoration(
                      labelText: "Gate",
                      icon: Icon(Icons.edit),
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: "e.g. 12",
                    ),
                    onChanged: (String value) {
                      this.searchGate = value;
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    controller: textBagController,
                    decoration: InputDecoration(
                      labelText: "Baggage Area",
                      icon: Icon(Icons.work),
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: "e.g. 5",
                    ),
                    onChanged: (String value) {
                      this.searchBag = value;
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RaisedButton(
                    child: Text("Show All Flights"),
                    onPressed: () {
                      FutureBuilder<dynamic>(
                          future: clearSearchConditions(),
                          builder: (context, snapshot) {
                            print('In Builder');
                          });
                      Navigator.pop(context, 'Search');
                    },

                  ),
                  RaisedButton(
                    child: Text("Search"),
                    onPressed: () {
                      FutureBuilder<dynamic>(
                          future: saveSearchConditions(),
                          builder: (context, snapshot) {
                            print('In Builder');
                          });
                      Navigator.pop(context, 'Search');
                    },

                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Flight Search"),
          backgroundColor: Colors.amber,
          elevation: 50.0,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    FutureBuilder<dynamic>(
                        future: saveSearchConditions(),
                        builder: (context, snapshot) {
                          print('In Builder');
                        });
                    Navigator.pop(context, 'Search');
                  },
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.more_vert),
                )),
          ],
        ));
  }
}
