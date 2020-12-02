import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

BuildContext scaffoldContext;

displaySnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );
  Scaffold.of(scaffoldContext).showSnackBar(snackBar);
}

void main() {
  runApp(MaterialApp(
    title: "M&M Smart Home",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getInitLedState(); // Getting initial state of LED, which is by default on
  }

  String _status = '';
  String url =
      'http://192.168.43.195/'; //IP Address which is configured in NodeMCU Sketch
  var response;

  getInitLedState() async {
    try {
      response = await http.get(url, headers: {"Accept": "plain/text"});
      setState(() {
        _status = 'zapnuto';
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      if (this.mounted) {
        setState(() {
          _status = 'nepripojeno';
        });
      }
    }
  }

  toggleLed() async {
    try {
      response = await http.get(url + 'led', headers: {"Accept": "plain/text"});
      setState(() {
        _status = response.body;
        print(response.body);
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      displaySnackBar(context, 'Modul neni pripojen');
    }
  }

  BuildContext scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.95),
      appBar: AppBar(
        title: Text("M&M Smart Home"),
        centerTitle: true,
      ),
      body: Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: toggleLed,
                    child: Text('Zapnout LED'),
                  ),
                ],
              ),
            ),
            Text(
              'LED status: $_status',
              textAlign: TextAlign.center,
            )
          ],
        );
      }),
    );
  }
}
