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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

  final tabs = [
    Center(child: Text('Settings')),
    Center(child: Text('Home')),
    Center(child: Text('History')),
  ];

  @override
  void initState() {
    super.initState();
    getInitLedState(); // Getting initial state of LED, which is by default on
  }

  String _status = '';
  String url =
      'http://192.168.43.48/'; //IP Address which is configured in NodeMCU Sketch
  var response;

  getInitLedState() async {
    try {
      response = await http.get(url, headers: {"Accept": "plain/text"});
      setState(() {
        _status = 'On';
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      if (this.mounted) {
        setState(() {
          _status = 'Not Connected';
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
      displaySnackBar(context, 'Module Not Connected');
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
                    child: Text('Toggle LED'),
                  ),
                ],
              ),
            ),
            Text(
              'LED Status: $_status',
              textAlign: TextAlign.center,
            )
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Nastavení'),
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Domů'),
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text('Historie'),
              backgroundColor: Colors.red,
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }
      ),
    );
  }
}
