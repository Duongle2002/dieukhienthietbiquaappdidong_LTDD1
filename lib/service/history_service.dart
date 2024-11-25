import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/models/history.dart';

class HistoryService {
  final String url = 'https://node-jserverdht11.onrender.com/api/history';

  // Hàm lấy dữ liệu và chuyển đổi thành danh sách các đối tượng HistoryItem
  Future<List<HistoryItem>> fetchHistoryData(String token) async {
    try {
      final response = await http.get(
        Uri.parse(url),

      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => HistoryItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load history data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
