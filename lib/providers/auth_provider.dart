import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'https://node-jserverdht11.onrender.com/auth';
  bool _isAuthenticated = false;
  String _token = '';
  String _errorMessage = ''; // Thêm lỗi thông báo cho người dùng

  bool get isAuthenticated => _isAuthenticated;
  String get token => _token;
  String get errorMessage => _errorMessage; // Getter cho errorMessage

  // Kiểm tra nếu token đã được lưu trữ và xác thực người dùng
  Future<void> checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  // Đăng ký người dùng
  Future<bool> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        _errorMessage = 'Registration failed: ${response.body}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error during registration: $e';
      notifyListeners();
      return false;
    }
  }

  // Đăng nhập và lưu trữ token
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String token = data['token'];
        print('Token: $token');

        // Lưu token vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        _token = token;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed: ${response.body}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error during login: $e';
      notifyListeners();
      return false;
    }
  }

  // Đăng xuất và xóa token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Xóa token khỏi SharedPreferences

    _token = '';
    _isAuthenticated = false;
    notifyListeners();
  }

  // Kiểm tra token có hết hạn hay không (nếu server hỗ trợ việc này)
  Future<bool> isTokenExpired() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/validateToken'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return false; // Token hợp lệ
      } else {
        return true; // Token không hợp lệ
      }
    } catch (e) {
      print('Error validating token: $e');
      return true; // Nếu có lỗi thì giả định token không hợp lệ
    }
  }
}
