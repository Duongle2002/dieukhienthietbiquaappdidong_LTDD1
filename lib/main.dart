import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/providers/auth_wrapper.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/register_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(), // Sử dụng home thay vì định nghĩa route '/'
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
