import 'package:M_M_Smart_Home/pages/settings.dart';
import 'package:M_M_Smart_Home/pages/sectorSettings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:M_M_Smart_Home/pages/history.dart';
import 'package:M_M_Smart_Home/pages/home.dart';
import 'package:M_M_Smart_Home/pages/sectorSettings.dart';

void main() {
  runApp(MaterialApp(
    title: ProjectSetup.projectTitle,
    debugShowCheckedModeBanner: false,
    home: Main(),
  ));
}

class ProjectSetup {
  static String url = 'http://192.168.137.1/laravel/maturita-web/api/';
  static String projectTitle = "M&M Smart Home";
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  BuildContext scaffoldContext;
  PageController _pageController = PageController();
  List<Widget> _screens = [Home(), Settings(), History(), SectorSettings()];

  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProjectSetup.projectTitle),
        backgroundColor: Colors.red,
      ),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _selectedIndex == 0 ? Colors.red : Colors.grey),
            title: Text(
              'Domů',
              style: TextStyle(
                  color: _selectedIndex == 0 ? Colors.red : Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,
                color: _selectedIndex == 1 ? Colors.red : Colors.grey),
            title: Text(
              'Nastavení',
              style: TextStyle(
                  color: _selectedIndex == 1 ? Colors.red : Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history,
                color: _selectedIndex == 2 ? Colors.red : Colors.grey),
            title: Text(
              'Historie',
              style: TextStyle(
                  color: _selectedIndex == 2 ? Colors.red : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
