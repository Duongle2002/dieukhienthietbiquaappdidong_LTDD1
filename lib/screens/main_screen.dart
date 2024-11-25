import 'package:flutter/material.dart';
import 'package:untitled/screens/customfooter.dart';
import 'package:untitled/screens/devicescreen.dart';
import 'package:untitled/screens/historyscreen.dart';
import 'package:untitled/screens/homepage.dart';
import 'package:untitled/screens/profilescreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Define your screens here
  static final List<Widget> _screens = <Widget>[
    const HomePage(),
    DeviceScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  // Method to handle item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: CustomFooter(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
