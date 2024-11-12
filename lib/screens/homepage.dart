import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(
            greeting: 'Good Morning',
            name: 'Le Hữu Dương',
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              childAspectRatio: 1.0, // Adjust this to control card aspect ratio
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0), // Spacing around each card
                  child: DeviceCard(
                    icon: Icons.lightbulb,
                    title: 'Lamp',
                    subtitle: 'Kitchen',
                    value: '',
                    isSwitch: true,
                    switchValue: true,
                    onSwitchChanged: (bool value) {
                      // Handle switch change
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DeviceCard(
                    icon: Icons.thermostat,
                    title: 'Temperature',
                    subtitle: 'Livingroom',
                    value: '30°C',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DeviceCard(
                    icon: Icons.water_drop,
                    title: 'Humidity',
                    subtitle: 'Livingroom',
                    value: '70%',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DeviceCard(
                    icon: Icons.speaker,
                    title: 'Speaker',
                    subtitle: 'Work office',
                    value: "",
                    isSwitch: true,
                    switchValue: false,
                    onSwitchChanged: (bool value) {
                      // Handle switch change
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DeviceCard(
                    icon: Icons.add,
                    title: '',
                    subtitle: '',
                    value: '',
                    onAddDevice: () {
                      // Handle adding a new device
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final bool isSwitch;
  final bool switchValue;
  final VoidCallback? onAddDevice;
  final ValueChanged<bool>? onSwitchChanged;

  const DeviceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.isSwitch = false,
    this.switchValue = false,
    this.onAddDevice,
    this.onSwitchChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.shade100,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36.0),
          SizedBox(height: 8.0),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          if (value.isNotEmpty)
            Text(value, style: TextStyle(fontSize: 24.0)),
          if (subtitle.isNotEmpty)
            Text(subtitle, style: TextStyle(color: Colors.grey)),
          if (isSwitch)
            Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
            ),
          if (onAddDevice != null)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: onAddDevice,
            ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String greeting;
  final String name;

  Header({required this.greeting, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200], // Background color for the header
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting and name
          Row(
            children: [
              Icon(Icons.sentiment_satisfied, size: 30),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Settings icon
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Handle add action
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Handle settings action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
