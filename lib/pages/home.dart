import 'package:flutter/material.dart';
import 'package:m_m_smart_home/main.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    readPhotoSensorData();
    super.initState();
  }

  String formattedDate =
      DateFormat('dd.MM.yyyy kk:mm').format(DateTime.now().toUtc());

  String welcomeText = "Dobrý den";
  String url = WifiSetup.url;
  String photoSensorValue = 'Neaktualizováno';
  var response;
  IconData timeIcon = WeatherIcons.day_sunny;

  readPhotoSensorData() async {
    try {
      response = await http
          .get(url + 'photo-sensor', headers: {"Accept": "plain/text"});
      setState(() {
        var photoSensorValue = double.parse(response.body);
        if (photoSensorValue < 300.00) {
          timeIcon = WeatherIcons.night_clear;
          welcomeText = "Dobrý večer";
        }
        print(photoSensorValue);
      });
    } catch (e) {
      photoSensorValue = 'Nelze načíst data';
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
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
            buildHeader(width, height),
            buildHeaderData(height, width),
            buildHeaderInfoCard(height, width),
            buildFloatingButton(width, height),
            buildNotificationPanel(width, height),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(double width, double height) {
    return Positioned(
      top: 30,
      child: Container(
        width: width,
        height: height * .30,
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
      top: (height * .30) / 2 - 40,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(color: Color(0xff2eb7a9), width: 3),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(
                      "https://images.csmonitor.com/csm/2012/11/babyinbucket.jpg?alias=standard_900x600nc"),
                )),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                welcomeText,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          Text(
            formattedDate,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderInfoCard(double height, double width) {
    return Positioned(
      top: height * .30 - 25,
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
                    Text("Check In"),
                    Text(
                      "9:00 AM",
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
                    Text("Check In"),
                    Text(
                      "NOT YET",
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

  Widget buildFloatingButton(double width, double height) {
    return Positioned(
      top: height - 85,
      width: width,
      child: Container(
        height: 70,
        width: 70,
        child: RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Color(0xff1a9bb1),
          elevation: 4,
          onPressed: () {},
          child: Icon(
            Icons.menu,
            size: 35,
            color: Colors.white,
          ),
        ),
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
                    buildBodyCardTitle(title: "Data z čidel"),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.day_sunny,
                        itemTitle: "Intenzita světla",
                        sensorValue: photoSensorValue),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.humidity,
                        itemTitle: "Vlhkost",
                        sensorValue: photoSensorValue),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: WeatherIcons.thermometer,
                        itemTitle: "Teplota",
                        sensorValue: photoSensorValue),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Material(
                elevation: 1,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildBodyCardTitle(title: "Invoice"),
                    Divider(
                      height: 2,
                      color: Colors.black87,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 10,
                        top: 10,
                        bottom: 10,
                      ),
                      leading: Card(
                        elevation: 2,
                        child: Container(
                          height: 70,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "MAY",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "21",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Invoce 1013",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "This month fate fee",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "PENDING",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        height: 70,
                        width: 80,
                        padding: const EdgeInsets.only(right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "\$1200",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 2),
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff1abcaa),
                              ),
                              child: Text(
                                "PLAY NOW",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 50),
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

  Widget buildNotificationItem({icon, String itemTitle, sensorValue}) {
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
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.timer,
                  color: Colors.grey,
                  size: 15,
                ),
                Text(
                  sensorValue,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
