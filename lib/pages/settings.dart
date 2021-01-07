import 'package:M_M_Smart_Home/pages/sectorSettings.dart';
import 'package:flutter/material.dart';
import 'package:M_M_Smart_Home/main.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  String _url = ProjectSetup.url;
  String _projectTitle = ProjectSetup.projectTitle;

  var response;

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
              buildContent(width, height),
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
                "Nastavení úrovní",
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

  Widget buildContent(double width, double height) {
    return Positioned(
      width: width,
      height: height * .70 - 40,
      top: height * 0.30 + 34,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 220),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Material(
                elevation: 1,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    buildBodyCardTitle(title: "Nastavení úrovní"),
                    buildItem(
                        link: SectorSettings(), title: "Nastavení priorit"),
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

  Widget buildItem({icon, link, String title}) {
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
        ),
        title: Text(
          title,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => link),
          );
        },
      ),
    );
  }
}
