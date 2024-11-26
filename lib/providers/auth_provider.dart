import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'https://node-jserverdht11.onrender.com/auth';
  bool _isAuthenticated = false;
  String _token = '';
  String _errorMessage = ''; // Error message to inform the user
  bool _isLoading = false; // Loading state flag

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get token => _token;
  String get errorMessage => _errorMessage; // Getter for errorMessage

  // Check if a token is saved and validate authentication
  Future<void> checkAuthenticationStatus() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      _isAuthenticated = true;
      _isLoading = false; // Stop loading
    } else {
      _isLoading = false; // Stop loading
    }
    notifyListeners();
  }

  // Register a new user
  Future<bool> register(User user) async {
    _isLoading = true; // Start loading
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        _isLoading = false; // Stop loading
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Registration failed: ${response.body}';
        _isLoading = false; // Stop loading
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error during registration: $e';
      _isLoading = false; // Stop loading
      notifyListeners();
      return false;
    }
  }

  // Login and store token
  Future<bool> login(String username, String password) async {
    _isLoading = true; // Start loading
    notifyListeners();

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

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        _token = token;
        _isAuthenticated = true;
        _isLoading = false; // Stop loading
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed: ${response.body}';
        _isLoading = false; // Stop loading
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error during login: $e';
      _isLoading = false; // Stop loading
      notifyListeners();
      return false;
    }
  }

  // Logout and remove token
  Future<void> logout() async {
    _isLoading = true; // Start loading
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove token from SharedPreferences

    _token = '';
    _isAuthenticated = false;
    _isLoading = false; // Stop loading
    notifyListeners();
  }

  // Check if the token is expired (if server supports this)
  Future<bool> isTokenExpired() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/validateToken'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return false; // Token is valid
      } else {
        return true; // Token is invalid
      }
    } catch (e) {
      print('Error validating token: $e');
      return true; // If there's an error, assume token is invalid
    }
  }
}
