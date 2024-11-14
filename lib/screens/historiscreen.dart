import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    fetchHistoryData();
  }

  Future<void> fetchHistoryData() async {
    final url = 'https://node-jserverdht11.onrender.com/api/history';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          historyData = data.map((item) => {
            'temperature': item['temperature'],
            'humidity': item['humidity'],
            'timestamp': item['timestamp'],
          }).toList();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to load history data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  String formatDate(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatTime(String timestamp) {
    final time = DateTime.parse(timestamp);
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {}, // Add your functionality here
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {}, // Add your functionality here
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final item = historyData[index];
          final date = formatDate(item['timestamp']);
          final time = formatTime(item['timestamp']);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0 || formatDate(historyData[index - 1]['timestamp']) != date)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(date, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item['temperature']}°C', style: TextStyle(fontSize: 16)),
                      Text('${item['humidity']}%', style: TextStyle(fontSize: 16)),
                      Text(time, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
