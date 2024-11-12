import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'https://node-jserverdht11.onrender.com/auth'; // URL của server Node.js
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> register(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("Registration failed: ${response.body}");
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Lưu token hoặc cập nhật trạng thái xác thực
      var data = json.decode(response.body);
      String token = data['token'];
      print('Token: $token');
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } else {
      print("Login failed: ${response.body}");
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
