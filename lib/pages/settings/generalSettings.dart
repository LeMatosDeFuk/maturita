import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:numberpicker/numberpicker.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const IconData check = IconData(0xe64c, fontFamily: 'MaterialIcons');
  final String apiUrl = ProjectSetup.url + "general-settings";

  @override
  void initState() {
    getDataFromServer();
    super.initState();
  }

  String _error;

  bool _morning = false;
  bool _evening = false;
  int _currentHumidity = 50;

  var response;

  sendDataToServer() {
    http.post(apiUrl, headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {
      "checkMorning": _morning.toString(),
      "checkEvening": _evening.toString(),
      "humidity": _currentHumidity
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(ProjectSetup.projectTitle),
        backgroundColor: Colors.blue,
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
                    colors: [Color(0xFF2196F3), Color(0xFFD3E6F3)],
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
                    buildBodyCardTitle(title: "Kontrolovat stav ráno (7:00)"),
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
                        if (sendDataToServer() == 200) {
                          final snackBar =
                              SnackBar(content: Text('Úspěšně uloženo'));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }
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
                        if (sendDataToServer() == 200) {
                          final snackBar =
                              SnackBar(content: Text('Úspěšně uloženo'));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                      },
                    ),
                    buildBodyCardTitle(title: "Zalévat od vlhkosti"),
                    buildNumberSelect(),
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

  Widget buildNumberSelect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new NumberPicker.integer(
            initialValue: _currentHumidity,
            minValue: 0,
            maxValue: 100,
            onChanged: (newValue) {
              setState(() => _currentHumidity = newValue);
            }),
      ],
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
