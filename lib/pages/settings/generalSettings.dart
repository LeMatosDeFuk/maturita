import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:flutter/services.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  static const IconData check = IconData(0xe64c, fontFamily: 'MaterialIcons');
  final String apiUrl = ProjectSetup.url + "general-settings";

  @override
  void initState() {
    getDataFromServer();
    super.initState();
  }

  String _error = null;

  bool _morning = false;
  bool _evening = false;

  var response;

  void sendDataToServer() {
    http.post(apiUrl, headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {
      "checkMorning": _morning.toString(),
      "checkEvening": _evening.toString(),
    }).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    });
  }

  getDataFromServer() async {
    try {
      response =
          await http.get(apiUrl, headers: {"Accept": "application/json"});

      var jsonResponse = json.decode(response.body);
      setState(() {
        _morning = jsonResponse['checkMorning'] == 0 ? false : true;
        _evening = jsonResponse['checkEvening'] == 0 ? false : true;
      });
    } catch (e) {
      print(e);
      _error = 'Nelze načíst data';
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _error = 'Nelze načíst data';
    return Scaffold(
      appBar: AppBar(
        title: Text(ProjectSetup.projectTitle),
        backgroundColor: Colors.red,
      ),
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
                    colors: [Color(0xFFFF504A), Color(0xFFFFAEAB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              buildHeaderData(height, width),
              _error != null
                  ? buildNotificationPanel(width, height)
                  : buildError(width, height),
              Divider(
                height: 3,
                color: Colors.black87,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextField(
                    decoration: new InputDecoration(labelText: "Enter your number"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                  ),
                ],
              )
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
                "Nastavení zalévání",
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

  Widget buildNotificationPanel(double width, double height) {
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
                    buildBodyCardTitle(title: "Kontrolovat stav ráno (16:00)"),
                    ToggleSwitch(
                      minWidth: 90.0,
                      initialLabelIndex: _morning == false ? 0 : 1,
                      cornerRadius: 20.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      labels: ['Ne', 'Ano'],
                      icons: [check, Icons.close],
                      activeBgColors: [Colors.red, Colors.green],
                      onToggle: (index) {
                        _morning = index == 0 ? false : true;
                        sendDataToServer();
                        print('switched to: $index');
                      },
                    ),
                    buildBodyCardTitle(title: "Kontrolovat stav večer (22:00)"),
                    ToggleSwitch(
                      minWidth: 90.0,
                      initialLabelIndex: _evening == false ? 0 : 1,
                      cornerRadius: 20.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      labels: ['Ne', 'Ano'],
                      icons: [check, Icons.close],
                      activeBgColors: [Colors.red, Colors.green],
                      onToggle: (index) {
                        _evening = index == 0 ? false : true;
                        sendDataToServer();
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
              color: Colors.red,
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
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
