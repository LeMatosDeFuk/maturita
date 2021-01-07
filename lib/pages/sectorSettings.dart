import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;

class SectorSettings extends StatefulWidget {
  @override
  _SectorSettingsState createState() => _SectorSettingsState();
}

class _SectorSettingsState extends State<SectorSettings> {
  @override
  void initState() {
    super.initState();
  }

  String _url = ProjectSetup.url;
  String _projectTitle = ProjectSetup.projectTitle;

  int _first = 1;
  int _second = 1;
  int _third = 1;
  int _fourth = 1;

  var response;

  void add(value) {
    setState(() {
      if (value < 4) value++;
    });
  }

  void minus(value) {
    setState(() {
      if (value != 1) value--;
    });
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
                height: height * .30,
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
      top: (height * .30) / 2 - 40,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              _projectTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Nastavení sektorů",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
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
      top: height * 0.30 + 34,
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
                    buildBodyCardTitle(title: "Nastavení priority sektoru 1"),
                    buildNumberInput("1", _first),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildBodyCardTitle(title: "Nastavení priority sektoru 2"),
                    buildNumberInput("2", _second),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildBodyCardTitle(title: "Nastavení priority sektoru 3"),
                    buildNumberInput("3", _third),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildBodyCardTitle(title: "Nastavení priority sektoru 4"),
                    buildNumberInput("4", _fourth),
                  ],
                ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    return Container(
      height: 50,
      width: 150,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new FloatingActionButton(
              heroTag: "buttonPlus" + number,
              onPressed: add(variable),
              child: new Icon(Icons.add, color: Colors.black),
              backgroundColor: Colors.white,
            ),
            new Text('$variable', style: new TextStyle(fontSize: 30.0)),
            new FloatingActionButton(
              heroTag: "buttonMinus" + number,
              onPressed: minus(variable),
              child: new Icon(Icons.remove, color: Colors.black),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
