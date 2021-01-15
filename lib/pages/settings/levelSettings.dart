import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;

class LevelSettings extends StatefulWidget {
  @override
  _LevelSettingsState createState() => _LevelSettingsState();
}

class _LevelSettingsState extends State<LevelSettings> {
  final String apiUrl = ProjectSetup.url + "sector-levels";

  @override
  void initState() {
    getDataFromServer();
    super.initState();
  }

  String _error = null;

  int _first = 1;
  int _second = 1;
  int _third = 1;
  int _fourth = 1;

  var response;

  sendDataToServer() {
    http.post(apiUrl, headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {
      "sector1Level": _first.toString(),
      "sector2Level": _second.toString(),
      "sector3Level": _third.toString(),
      "sector4Level": _fourth.toString(),
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
        _first = int.parse(jsonResponse[0]['level']);
        _second = int.parse(jsonResponse[1]['level']);
        _third = int.parse(jsonResponse[2]['level']);
        _fourth = int.parse(jsonResponse[3]['level']);
      });
    } catch (e) {
      print(e);
      _error = 'Nelze načíst data';
    }
  }

  void add(number, numberVariable) {
    setState(() {
      if (number < 4) number++;
      assignVariable(number, numberVariable);
    });
  }

  void minus(number, numberVariable) {
    setState(() {
      if (number != 1) number--;
      assignVariable(number, numberVariable);
    });
  }

  void assignVariable(number, numberVariable) {
    switch (numberVariable) {
      case "1":
        _first = number;
        break;
      case "2":
        _second = number;
        break;
      case "3":
        _third = number;
        break;
      case "4":
        _fourth = number;
        break;
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
              buildNotificationPanel(width, height),
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
                "Nastavení priorit",
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
      height: height * .70 - 40,
      top: height * 0.20 + 34,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Material(
                elevation: 1,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    buildBodyCardTitle(title: "Sektor 1"),
                    buildNumberInput("1", _first),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildBodyCardTitle(title: "Sektor 2"),
                    buildNumberInput("2", _second),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildBodyCardTitle(title: "Sektor 3"),
                    buildNumberInput("3", _third),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildBodyCardTitle(title: "Sektor 4"),
                    buildNumberInput("4", _fourth),
                  ],
                ),
              ),
              Divider(height: 20, color: Colors.transparent),
              Builder(
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
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBodyCardTitle({String title}) {
    return Container(
      padding: const EdgeInsets.all(15),
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

  Widget buildNotificationItem(
      {icon, String itemTitle, sensorValue, additionalSymbol}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10),
        leading: Container(
          height: 40,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: BoxedIcon(
            icon,
            size: 20,
            color: Colors.white70,
          ),
        ),
        title: Text(
          itemTitle,
        ),
        trailing: Container(
          height: 40,
          width: 140,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 1,
                color: Colors.black26,
              ),
            ),
          ),
          child: Center(
              child: Text(
            sensorValue + additionalSymbol,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          )),
        ),
      ),
    );
  }

  Widget buildNumberInput(number, variable) {
    if (_error == null) {
      return Container(
        height: 50,
        width: 150,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: new Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new FloatingActionButton(
                heroTag: "buttonMinus" + number,
                onPressed: () => minus(variable, number),
                child: new Icon(Icons.remove, color: Colors.black),
                backgroundColor: Colors.white,
              ),
              new Text('$variable', style: new TextStyle(fontSize: 20.0)),
              new FloatingActionButton(
                heroTag: "buttonPlus" + number,
                onPressed: () => add(variable, number),
                child: new Icon(Icons.add, color: Colors.black),
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 50,
        width: 150,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Center(
            child: Text(
          _error,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
          ),
        )),
      );
    }
  }
}
