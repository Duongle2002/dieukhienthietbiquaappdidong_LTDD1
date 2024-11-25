import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Đảm bảo thêm package provider
import 'package:untitled/models/history.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/service/history_service.dart';
import 'dart:async';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> historyData = [];
  final HistoryService _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    fetchHistoryData();
  }

  Future<void> fetchHistoryData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // Sử dụng đúng kiểu dữ liệu

    if (!authProvider.isAuthenticated) {
      // Nếu người dùng chưa đăng nhập, thông báo và không tải dữ liệu
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not authenticated. Please login first.')),
      );
      return;
    }

    try {
      // Gửi yêu cầu với token trong header
      final data = await _historyService.fetchHistoryData(authProvider.token);
      setState(() {
        historyData = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching history data')),
      );
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
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {}, // Add your functionality here
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {}, // Add your functionality here
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchHistoryData, // Implement pull-to-refresh
        child: historyData.isEmpty
            ? const Center(child: Text('No history data available'))
            : ListView.builder(
          itemCount: historyData.length,
          itemBuilder: (context, index) {
            final item = historyData[index];
            final timestamp = item.timestamp?.toString() ?? ''; // Ensure timestamp is a String
            final date = formatDate(timestamp);
            final time = formatTime(timestamp);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0 ||
                      formatDate(historyData[index - 1].timestamp?.toString() ?? '') != date)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(date,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.temperature}°C', style: const TextStyle(fontSize: 16)),
                        Text('${item.humidity}%', style: const TextStyle(fontSize: 16)),
                        Text(time, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  const Divider(), // Thêm Divider để phân cách giữa các mục lịch sử
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
