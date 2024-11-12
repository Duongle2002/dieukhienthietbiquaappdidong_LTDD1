import 'package:flutter/material.dart';


class CustomFooter extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomFooter({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.lightBlue[50],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.memory),
          label: 'Device',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}