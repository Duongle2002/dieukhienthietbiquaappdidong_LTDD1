import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserRepository {
  final String _baseUrl = 'https://node-jserverdht11.onrender.com';

  Future<User?> fetchUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        print('Lỗi khi lấy thông tin: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
      return null;
    }
  }
}
