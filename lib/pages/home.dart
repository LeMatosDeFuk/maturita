import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String sensorDataUrl = ProjectSetup.url + "sensor-data-latest";
  final String actionsUrl = ProjectSetup.url + "actions";

  @override
  void initState() {
    readSensorData();
    readActions();
    super.initState();
  }

  String _formattedDate =
      DateFormat('dd.MM.yyyy kk:mm').format(DateTime.now().toLocal());

  String _welcomeText = "Dobrý den";
  String _statusText = "Načítám data";

  String _photoSensorValue = 'Načítám data';
  String _temperatureSensorValue = 'Načítám data';
  String _waterSensorValue = 'Načítám data';
  double _waterSensorData = 20.32;
  String _nextControl = "21:00";

  bool _sector1 = false;
  bool _sector2 = false;
  bool _sector3 = false;
  bool _sector4 = false;

  String _sector1Text = 'Načítám data';
  String _sector2Text = 'Načítám data';
  String _sector3Text = 'Načítám data';
  String _sector4Text = 'Načítám data';

  var response;
  var responseActions;
  IconData timeIcon = WeatherIcons.day_sunny;

  readActions() async {
    try {
      responseActions =
          await http.get(actionsUrl, headers: {"Accept": "application/json"});

      var jsonResponseActions = json.decode(responseActions.body);

      setState(() {
        _sector1 = jsonResponseActions['sector1'];
        _sector2 = jsonResponseActions['sector2'];
        _sector3 = jsonResponseActions['sector3'];
        _sector4 = jsonResponseActions['sector4'];

        _sector1Text = _sector1 ? "Nezalito" : "Zalito";
        _sector2Text = _sector2 ? "Nezalito" : "Zalito";
        _sector3Text = _sector3 ? "Nezalito" : "Zalito";
        _sector4Text = _sector4 ? "Nezalito" : "Zalito";

        if (!_sector1 || !_sector2 || !_sector3 || !_sector4) {
          _statusText = "Nezalito";
        } else {
          _statusText = "Zalito";
        }
      });
    } catch (e) {
      setState(() {
        _sector1Text = 'Nelze načíst data';
        _sector2Text = 'Nelze načíst data';
        _sector3Text = 'Nelze načíst data';
        _sector4Text = 'Nelze načíst data';
        _statusText = 'Nelze načíst data';
      });
    }
  }

  readSensorData() async {
    try {
      response = await http
          .get(sensorDataUrl, headers: {"Accept": "application/json"});

      var jsonResponse = json.decode(response.body);

      setState(() {
        _temperatureSensorValue =
            jsonResponse['temperature'].toString() + "\u2103";
        _photoSensorValue = jsonResponse['lighting'].toString() + "%";
        _waterSensorValue = jsonResponse['waterLevel'].toString() + "%";
        _waterSensorData = jsonResponse['waterLevel'];
        int _photoSensorData = jsonResponse['lighting'];

        if (_photoSensorData < 30) {
          timeIcon = WeatherIcons.night_clear;
          _welcomeText = "Dobrý večer";
          _nextControl = "8:00";
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        _photoSensorValue = 'Nelze načíst data';
        _temperatureSensorValue = 'Nelze načíst data';
        _waterSensorValue = 'Nelze načíst data';
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
          height: height + 100,
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
              buildHeader(width, height),
              buildHeaderData(height, width),
              buildHeaderInfoCard(height, width),
              buildPanel(width, height),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(double width, double height) {
    return Positioned(
      top: 30,
      child: Container(
        width: width,
        height: height * .20,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BoxedIcon(
                    timeIcon,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeaderData(double height, double width) {
    return Positioned(
      top: (height * .20) / 2 - 40,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              _welcomeText,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Dnes je " + _formattedDate,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderInfoCard(double height, double width) {
    return Positioned(
      top: height * .20 - 25,
      width: width,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          height: 50,
          width: width * .65,
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text("Stav"),
                    Text(
                      _statusText,
                      style: TextStyle(
                        color: Color(0xff053150),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.access_time,
                  size: 35,
                  color: Colors.grey,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Další kontrola"),
                    Text(
                      _nextControl,
                      style: TextStyle(
                        color: Color(0xff053150),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPanel(double width, double height) {
    return Positioned(
      width: width,
      height: height,
      top: height * 0.20 + 34,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Material(
                child: Column(
                  children: <Widget>[
                    buildBodyCardTitle(title: "Data z čidel"),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildWaterBar(),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.day_sunny,
                        itemTitle: "Intenzita světla",
                        sensorValue: _photoSensorValue,
                        backgroundColor: Color(0xFFFFC800)),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.thermometer,
                        itemTitle: "Teplota",
                        sensorValue: _temperatureSensorValue,
                        backgroundColor: Colors.red),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.raindrop,
                        itemTitle: "Sektor 1",
                        sensorValue: _sector1Text,
                        backgroundColor: Colors.blue),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.raindrop,
                        itemTitle: "Sektor 2",
                        sensorValue: _sector2Text,
                        backgroundColor: Colors.blue),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.raindrop,
                        itemTitle: "Sektor 3",
                        sensorValue: _sector3Text,
                        backgroundColor: Colors.blue),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.raindrop,
                        itemTitle: "Sektor 4",
                        sensorValue: _sector4Text,
                        backgroundColor: Colors.blue),
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
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWaterBar(
      {icon, String itemTitle, sensorValue, additionalSymbol}) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Hladina vody v nádrži',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 130,
                  width: 130,
                  child: LiquidCircularProgressIndicator(
                    value: _waterSensorData / 100,
                    // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(Color(0xFF69B8FF)),
                    backgroundColor: Colors.white,
                    borderColor: Colors.blue,
                    borderWidth: 4.0,
                    direction: Axis.vertical,
                    center: Text(
                      _waterSensorValue,
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget buildNotificationItem(
      {icon, String itemTitle, sensorValue, backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10),
        leading: Container(
          height: 40,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: BoxedIcon(
            icon,
            size: 20,
            color: Colors.white,
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
            sensorValue,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          )),
        ),
      ),
    );
  }
}
