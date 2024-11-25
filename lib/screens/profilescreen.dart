import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _birthdayController;
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _locationController = TextEditingController();
    _birthdayController = TextEditingController();

    _getProfile();
  }

  Future<void> _getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not logged in!')),
        );
        return;
      }
      final response = await http.get(
        Uri.parse('https://node-jserverdht11.onrender.com/auth/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _user = User.fromJson(data);
          _nameController.text = _user?.userDisplayName ?? '';
          _locationController.text = _user?.location ?? '';
          _birthdayController.text = _user?.birthday?.toIso8601String() ?? '';
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile')),
        );
      }
    } catch (e) {
      print('Error fetching profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred!')),
      );
    }
  }
  Future<void> _updateProfile() async {
    if (_user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not logged in!')),
        );
        return;
      }
      final updatedUser = User(
        username: _user!.username,
        email: _user!.email,
        password: '', // Không gửi mật khẩu khi cập nhật
        userDisplayName: _nameController.text,
        gender: _user!.gender,
        location: _locationController.text,
        birthday: DateTime.tryParse(_birthdayController.text),
      );

      final response = await http.put(
        Uri.parse('https://node-jserverdht11.onrender.com/api/user/${_user!.username}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred!')),
      );
    }
  }

  Future<void> _logout() async {
    final authProvider = AuthProvider();
    await authProvider.logout();  // Gọi phương thức logout từ AuthProvider
    Navigator.pushReplacementNamed(context, '/login');  // Chuyển hướng đến màn hình đăng nhập
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(labelText: 'Birthday'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your birthday';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _updateProfile();
                  }
                },
                child: Text('Update Profile'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,  // Đăng xuất khi nút được nhấn
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
