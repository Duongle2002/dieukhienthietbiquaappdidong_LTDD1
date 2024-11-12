import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/screens/customfooter.dart';
import 'package:untitled/screens/devicescreen.dart';
import 'package:untitled/screens/historiscreen.dart';
import 'package:untitled/screens/homepage.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/profilescreen.dart';
import 'package:untitled/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Auth App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthWrapper(),
        routes: {
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}

// Widget to check if user is logged in or not
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Check if user is authenticated, if yes navigate to MainScreen, else LoginScreen
    return authProvider.isAuthenticated ? MainScreen() : LoginScreen();
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Define your screens here
  static List<Widget> _screens = <Widget>[
    HomePage(),
    DeviceScreen(),
    HistoriScreen(),
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
