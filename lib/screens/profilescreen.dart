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
    _fetchProfile();
  }

  /// Lấy thông tin người dùng từ API
  Future<void> _fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print("Token fetched: $token");

      if (token == null) {
        // Người dùng chưa đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not logged in!')),
        );
        Navigator.pushReplacementNamed(context, '/login'); // Chuyển hướng đến màn hình đăng nhập
        return;
      }

      final response = await http.get(
        Uri.parse('https://node-jserverdht11.onrender.com/auth/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Kiểm tra xem có dữ liệu trong response hay không
        if (data.isEmpty) {
          print("No profile data found.");
          setState(() {
            _isLoading = false;
          });
          return;
        }

        print("Profile data fetched: $data");

        setState(() {
          _user = User.fromJson(data);
          _nameController.text = _user?.userDisplayName ?? '';
          _locationController.text = _user?.location ?? '';
          _birthdayController.text =
          _user?.birthday != null ? _user!.birthday!.toIso8601String() : '';
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        // Token không hợp lệ, yêu cầu người dùng đăng nhập lại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session expired. Please log in again.')),
        );
        Navigator.pushReplacementNamed(context, '/login'); // Chuyển hướng đến màn hình đăng nhập
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

  /// Cập nhật thông tin người dùng
  Future<void> _updateProfile() async {
    if (_user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not logged in!')),
        );
        Navigator.pushReplacementNamed(context, '/login'); // Chuyển hướng đến màn hình đăng nhập
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

  /// Đăng xuất người dùng
  Future<void> _logout() async {
    final authProvider = AuthProvider();
    await authProvider.logout();
    Navigator.pushReplacementNamed(context, '/login');
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
                onPressed: _logout,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final String username;
  final String email;
  final String password; // Mật khẩu có thể không cần khi lấy từ API
  final String? userDisplayName;
  final String? role;
  final DateTime? birthday;
  final String gender;
  final String? location;

  User({
    required this.username,
    required this.email,
    this.password = '', // Giá trị mặc định nếu không cần mật khẩu
    this.userDisplayName,
    this.role,
    this.birthday,
    this.gender = 'other', // Mặc định là 'other' nếu không có giá trị
    this.location,
  });

  /// Phương thức để chuyển đối tượng User thành JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'userDisplayName': userDisplayName,
      'role': role,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'location': location,
    };
  }

  /// Phương thức để tạo đối tượng User từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] ?? '', // Gán giá trị mặc định cho password
      userDisplayName: json['userDisplayName'] as String?,
      role: json['role'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'])
          : null, // Nếu birthday null thì trả về null
      gender: json['gender'] ?? 'other', // Gán giá trị mặc định nếu gender null
      location: json['location'] as String?,
    );
  }
}
