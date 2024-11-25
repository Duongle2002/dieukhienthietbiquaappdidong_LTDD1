class HistoryItem {
  final DateTime timestamp;
  final double temperature;
  final double humidity;

  HistoryItem({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
  });

  // Phương thức để tạo đối tượng HistoryItem từ JSON nếu bạn nhận dữ liệu từ API
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      timestamp: DateTime.parse(json['timestamp']),
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
    );
  }

  // Phương thức để chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
    };
  }
}
