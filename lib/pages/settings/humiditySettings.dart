import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:numberpicker/numberpicker.dart';

class HumiditySettings extends StatefulWidget {
  @override
  _HumiditySettingsState createState() => _HumiditySettingsState();
}

class _HumiditySettingsState extends State<HumiditySettings> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const IconData check = IconData(0xe64c, fontFamily: 'MaterialIcons');
  final String apiUrl = ProjectSetup.url + "general-settings";

  @override
  void initState() {
    getDataFromServer();
    super.initState();
  }

  int _currentWaterLevel1 = 50;
  int _currentWaterLevel2 = 50;
  int _currentWaterLevel3 = 50;
  int _currentWaterLevel4 = 50;
  bool _fetchedData = false;
  String _error = 'Načítám data';

  var response;

  sendDataToServer() {
    http.post(apiUrl, headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {
      "waterLevel1": _currentWaterLevel1.toString(),
      "waterLevel2": _currentWaterLevel2.toString(),
      "waterLevel3": _currentWaterLevel3.toString(),
      "waterLevel4": _currentWaterLevel4.toString()
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
        _currentWaterLevel1 = jsonResponse['waterLevel1'];
        _currentWaterLevel2 = jsonResponse['waterLevel2'];
        _currentWaterLevel3 = jsonResponse['waterLevel3'];
        _currentWaterLevel4 = jsonResponse['waterLevel4'];
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
          height: height + 350,
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
                "Nastavení zavlažování",
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
                        title: "Zalévat sektor 1 od hladiny vody (%)"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new NumberPicker.integer(
                            initialValue: _currentWaterLevel1,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (newValue1) {
                              setState(() =>  _currentWaterLevel1 = newValue1);
                            }),
                      ],
                    ),
                    buildBodyCardTitle(
                        title: "Zalévat sektor 2 od hladiny vody (%)"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new NumberPicker.integer(
                            initialValue: _currentWaterLevel2,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (newValue2) {
                              setState(() =>  _currentWaterLevel2 = newValue2);
                            }),
                      ],
                    ),
                    buildBodyCardTitle(
                        title: "Zalévat sektor 3 od hladiny vody (%)"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new NumberPicker.integer(
                            initialValue: _currentWaterLevel3,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (newValue3) {
                              setState(() =>  _currentWaterLevel3 = newValue3);
                            }),
                      ],
                    ),
                    buildBodyCardTitle(
                        title: "Zalévat sektor 4 od hladiny vody (%)"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new NumberPicker.integer(
                            initialValue: _currentWaterLevel4,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (newValue4) {
                              setState(() =>  _currentWaterLevel4 = newValue4);
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
