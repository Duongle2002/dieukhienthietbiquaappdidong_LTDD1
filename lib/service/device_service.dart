// device_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceService {
  final String serverIp ;
  DeviceService({required this.serverIp});
  Future<Map<String, dynamic>> fetchDeviceStatus() async {
    final response = await http.get(Uri.parse('$serverIp/getDeviceStatus'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load device status');
      return {};
    }
  }

  Future<Map<String, String>> fetchSensorData() async {
    final response = await http.get(Uri.parse('$serverIp/api/sensorData'));
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        return {
          'temperature': data['temperature']?.toString() ?? 'N/A',
          'humidity': data['humidity']?.toString() ?? 'N/A',
        };
      } catch (e) {
        print('JSON decode error: $e');
        return {'temperature': 'N/A', 'humidity': 'N/A'};
      }
    } else {
      print('Failed to load sensor data: ${response.body}');
      return {'temperature': 'N/A', 'humidity': 'N/A'};
    }
  }

  Future<void> setDeviceStatus(String device, String status) async {
    final response = await http.post(
      Uri.parse('$serverIp/setDeviceStatus'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'device': device, 'status': status}),
    );

    if (response.statusCode != 200) {
      print('Failed to set device status');
    }
  }
}
