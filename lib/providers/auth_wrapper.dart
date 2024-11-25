import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/main_screen.dart';
import 'auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Kiểm tra trạng thái đăng nhập
    authProvider.checkAuthenticationStatus();

    // Kiểm tra nếu người dùng đã xác thực, chuyển hướng đến MainScreen, nếu chưa thì LoginScreen
    return authProvider.isAuthenticated ? MainScreen() : LoginScreen();
  }
}
