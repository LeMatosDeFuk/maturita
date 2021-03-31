import 'dart:async';
import 'dart:convert';
import 'package:M_M_Smart_Home/main.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  @override
  HistoryState createState() => new HistoryState();
}

class HistoryState extends State<History> {
  List data;
  final String apiUrl = ProjectSetup.url + "water-history";

  Future<String> getData() async {
    var response = await http
        .get(Uri.encodeFull(apiUrl), headers: {"Accept": "application/json"});

    this.setState(() {
      data = json.decode(response.body);
    });
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: width,
                height: height,
                child: Stack(children: <Widget>[
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
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    width: width,
                    height: height * .20,
                    child: new Padding(
                        padding: const EdgeInsets.all(15),
                        child: new Text(
                          'Posledních 10 hodnot hladiny vody',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ),
                  new ListView.builder(
                      padding: EdgeInsets.only(top: 200),
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                          child: new Padding(
                              padding: const EdgeInsets.all(15),
                              child: new Text(data[index]["waterLevel"] + "%",
                                  textAlign: TextAlign.center)),
                        );
                      }),
                ]))));
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
                "Historie",
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
}
