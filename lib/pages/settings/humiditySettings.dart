import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';

class HumiditySettings extends StatefulWidget {
  @override
  _HumiditySettingsState createState() => _HumiditySettingsState();
}

class _HumiditySettingsState extends State<HumiditySettings> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String apiUrl = ProjectSetup.url + "general-settings";

  @override
  void initState() {
    getDataFromServer();
    super.initState();
  }

  int _currentHumidity1 = 50;
  int _currentHumidity2 = 50;
  int _currentHumidity3 = 50;
  int _currentHumidity4 = 50;
  bool _fetchedData = false;
  String _error = 'Načítám data';

  var response;

  sendDataToServer() {
    http.post(apiUrl, headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {
      "humidity1": _currentHumidity1.toString(),
      "humidity2": _currentHumidity2.toString(),
      "humidity3": _currentHumidity3.toString(),
      "humidity4": _currentHumidity4.toString()
    }).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    });

    return response.statusCode;
  }

  getDataFromServer() async {
    try {
      response =
          await http.get(apiUrl, headers: {"Accept": "application/json"});

      var jsonResponse = json.decode(response.body);
      setState(() {
        _currentHumidity1 = jsonResponse['humidity1'];
        _currentHumidity2 = jsonResponse['humidity2'];
        _currentHumidity3 = jsonResponse['humidity3'];
        _currentHumidity4 = jsonResponse['humidity4'];
        _fetchedData = true;
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(ProjectSetup.projectTitle),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height + 300,
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
              _fetchedData == true
                  ? buildBody(width, height)
                  : buildError(width, height),
              Divider(
                height: 3,
                color: Colors.black87,
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
                "Nastavení vlhkosti pro sektory",
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

  Widget buildBody(double width, double height) {
    return Positioned(
      width: width,
      top: height * 0.20,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 30),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Material(
                child: Column(
                  children: <Widget>[
                    buildBodyCardTitle(
                        title: "Zalévat sektor 1 od vlhkosti (%)"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new NumberPicker.integer(
                            initialValue: _currentHumidity1,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (newValue1) {
                              setState(() =>  _currentHumidity1 = newValue1);
                            }),
                      ],
                    ),
                    buildBodyCardTitle(
                        title: "Zalévat sektor 2 od vlhkosti (%)"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new NumberPicker.integer(
                            initialValue: _currentHumidity2,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (newValue2) {
                              setState(() =>  _currentHumidity2 = newValue2);
                            }),
                      ],
                    ),
                    buildBodyCardTitle(
                        title: "Zalévat sektor 3 od vlhkosti (%)"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new NumberPicker.integer(
                            initialValue: _currentHumidity3,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (newValue3) {
                              setState(() =>  _currentHumidity3 = newValue3);
                            }),
                      ],
                    ),
                    buildBodyCardTitle(
                        title: "Zalévat sektor 4 od vlhkosti (%)"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new NumberPicker.integer(
                            initialValue: _currentHumidity4,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (newValue4) {
                              setState(() =>  _currentHumidity4 = newValue4);
                            }),
                      ],
                    ),
                    buildSaveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return Builder(
      builder: (BuildContext context) {
        return Center(
          child: FlatButton(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            onPressed: () {
              if (sendDataToServer() == 200) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Úspěšně uloženo'),
                ));
              }
            },
            child: Text(
              'Uložit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: Colors.blue,
          ),
        );
      },
    );
  }

  Widget buildError(double width, double height) {
    return Positioned(
      width: width,
      top: height * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _error,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBodyCardTitle({String title}) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
