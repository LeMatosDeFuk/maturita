import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'dart:convert';

final String readFrom = ProjectSetup.url + "get-data";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    readPhotoSensorData();
    readDallasSensorData();
    readWaterSensorData();

    super.initState();
  }

  String _formattedDate =
      DateFormat('dd.MM.yyyy kk:mm').format(DateTime.now().toUtc());

  String _welcomeText = "Dobrý den";

  String _photoSensorValue = 'Neaktualizováno';

  String _dallasSensorValue = 'Neaktualizováno';
  String _dallasSensorSymbol = "";

  String _waterSensorSymbol = "";
  String _waterSensorValue = 'Neaktualizováno';
  double _waterSensorData = 20.0;

  var response;
  IconData timeIcon = WeatherIcons.day_sunny;

  readPhotoSensorData() async {
    try {
      response =
          await http.get(readFrom, headers: {"Accept": "application/json"});

      var jsonResponse = json.decode(response.body);
      print(jsonResponse);

      setState(() {
        double photoSensorData = double.parse(jsonResponse['lighting']);
        _photoSensorValue = photoSensorData.toString();

        if (photoSensorData < 300.00) {
          timeIcon = WeatherIcons.night_clear;
          _welcomeText = "Dobrý večer";
        }
      });
    } catch (e) {
      _photoSensorValue = 'Nelze načíst data';
    }
  }

  readDallasSensorData() async {
    try {
      response =
          await http.get(readFrom, headers: {"Accept": "application/json"});

      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      setState(() {
        _dallasSensorSymbol = " \u2103";
        _dallasSensorValue = jsonResponse['temperature'];
      });
    } catch (e) {
      _photoSensorValue = 'Nelze načíst data';
    }
  }

  readWaterSensorData() async {
    try {
      response =
          await http.get(readFrom, headers: {"Accept": "application/json"});

      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      setState(() {
        _waterSensorValue = jsonResponse['humidity'];
        double _waterSensorData = double.parse(_waterSensorValue);
        _waterSensorSymbol = "%";
      });
    } catch (e) {
      _waterSensorValue = 'Nelze načíst data';
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
                    colors: [Color(0xFFFF504A), Color(0xFFFFAEAB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              buildHeader(width, height),
              buildHeaderData(height, width),
              buildHeaderInfoCard(height, width),
              buildNotificationPanel(width, height),
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
                      "Vše zalito",
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
                      "9:00",
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
                        additionalSymbol: ""),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.humidity,
                        itemTitle: "Vlhkost",
                        sensorValue: _photoSensorValue,
                        additionalSymbol: ""),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.thermometer,
                        itemTitle: "Teplota",
                        sensorValue: _dallasSensorValue,
                        additionalSymbol: _dallasSensorSymbol),
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
                    valueColor: AlwaysStoppedAnimation(Colors.red),
                    backgroundColor: Colors.white,
                    borderColor: Colors.red,
                    borderWidth: 4.0,
                    direction: Axis.vertical,
                    center: Text(
                      _waterSensorValue.toString() + _waterSensorSymbol,
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
}
