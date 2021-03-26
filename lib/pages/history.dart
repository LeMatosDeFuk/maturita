import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  @override
  void initState() {
    getDataFromServer();
    super.initState();
  }

  final String apiUrl = ProjectSetup.url + "sensor-data";

  var response;
  bool _fetchedData = false;
  String _error = 'Načítám data';
  List<int> entries = <int>[
    123,1234,12345
  ];
  List<int> colorCodes = <int>[
    1000,
    900,
    800,
    700,
    600,
    500,
    400,
    300,
    200,
    100
  ];

  getDataFromServer() async {
    try {
      response =
          await http.get(apiUrl, headers: {"Accept": "application/json"});

      var jsonResponse = json.decode(response.body);
      setState(() {
        response = jsonResponse;
        _fetchedData = true;

        var waterLevels = jsonResponse['waterLevel'];
        print(waterLevels);
        List<int> entries =
            waterLevels != null ? List.from(waterLevels) : null;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = 'Nelze načíst data';
      });
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                width: width,
                height: height * .20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFFD3E6F3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              buildHeaderData(height, width),
              ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: entries != null ? entries.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.amber[colorCodes[index]],
                    child: Center(child: Text('Entry ${entries[index]}')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderData(double height, double width) {
    return Positioned(
      top: (height * .20) / 2 - 20,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Historie",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBodyCardTitle({String title}) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
