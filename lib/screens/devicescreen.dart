import 'package:flutter/material.dart';

class DeviceScreen extends StatelessWidget {
  void _toggleDevice(bool newState) {
    // Handle the toggle action (turn on/off device)
    print('Device toggled: $newState');
  }

  void _openSettings() {
    // Open settings when the settings button is pressed
    print('Settings opened');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Control'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          DeviceWidget(
            deviceName: 'Smart Light',
            location: 'Living Room',
            isOn: false,
            onToggle: _toggleDevice,
            onSettings: _openSettings,
          ),
          DeviceWidget(
            deviceName: 'Air Conditioner',
            location: 'Bedroom',
            isOn: true,
            onToggle: _toggleDevice,
            onSettings: _openSettings,
          ),
        ],
      ),
    );
  }
}

class DeviceWidget extends StatelessWidget {
  final String deviceName;
  final String location;
  final bool isOn;
  final ValueChanged<bool> onToggle;
  final VoidCallback onSettings;

  DeviceWidget({
    required this.deviceName,
    required this.location,
    required this.isOn,
    required this.onToggle,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.black54),
              SizedBox(width: 8.0),
              Text(
                deviceName,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Switch(
                value: isOn,
                onChanged: onToggle,
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: onSettings,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                location,
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
              Spacer(),
              _buildTimerOption("15'", context),
              _buildTimerOption("30'", context),
              _buildTimerOption("1h", context),
              _buildTimerOption("2h", context),
              TextButton(
                onPressed: () {}, // Set time button action
                child: Text("set time >", style: TextStyle(color: Colors.black54)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerOption(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}