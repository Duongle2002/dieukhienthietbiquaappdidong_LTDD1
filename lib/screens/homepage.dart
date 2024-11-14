import 'package:flutter/material.dart';
import 'package:untitled/service/device_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final DeviceService deviceService = DeviceService(serverIp: 'https://node-jserverdht11.onrender.com');
  Map<String, dynamic> deviceStatus = {};
  String? temperature;
  String? humidity;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await fetchDeviceStatus();
    await fetchSensorData();
  }

  Future<void> fetchDeviceStatus() async {
    final status = await deviceService.fetchDeviceStatus();
    setState(() {
      deviceStatus = status;
    });
  }

  Future<void> fetchSensorData() async {
    final data = await deviceService.fetchSensorData();
    setState(() {
      temperature = data['temperature'] ?? 'Loading...';
      humidity = data['humidity'] ?? 'Loading...';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadData();
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
              childAspectRatio: 1.0,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DeviceCard(
                    icon: Icons.lightbulb,
                    isicon : true,
                    title: 'Lamp',
                    subtitle: 'Kitchen',
                    value: 'Lamp',
                    isSwitch: true,
                    switchValue: deviceStatus['DEVICE1'] == 'ON',
                    bgColor: Colors.deepPurpleAccent,
                    onSwitchChanged: (bool value) {
                      setDeviceStatus('DEVICE1', value ? 'ON' : 'OFF');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DeviceCard(
                    icon: Icons.lightbulb,
                    isicon : true,
                    title: 'Lamp 2',
                    subtitle: 'Living Room',
                    value: 'Lamp 2',
                    isSwitch: true,
                    switchValue: deviceStatus['DEVICE2'] == 'ON',
                    onSwitchChanged: (bool value) {
                      setDeviceStatus('DEVICE2', value ? 'ON' : 'OFF');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DeviceCard(
                    icon: Icons.thermostat,
                    isicon : true,
                    title: 'Temperature',
                    subtitle: 'Livingroom',
                    value: (temperature != null && temperature!.isNotEmpty) ? temperature! + '℃' : 'N/A',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DeviceCard(
                    icon: Icons.water_drop,
                    isicon : true,
                    title: 'Humidity',
                    subtitle: 'Livingroom',
                    value: (humidity != null && humidity!.isNotEmpty) ? humidity! + '%' : 'N/A',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DeviceCard(
                    icon: Icons.speaker,
                    isicon : true,
                    title: 'Speaker',
                    subtitle: 'Work office',
                    value: 'Speaker',
                    isSwitch: true,
                    switchValue: deviceStatus['DEVICE3'] == 'ON',
                    onSwitchChanged: (bool value) {
                      setDeviceStatus('DEVICE3', value ? 'ON' : 'OFF');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DeviceCard(

                    icon: Icons.add,
                    isicon : false,
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

  Future<void> setDeviceStatus(String device, String status) async {
    await deviceService.setDeviceStatus(device, status);
    setState(() {
      deviceStatus[device] = status;
    });
  }
}

class DeviceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final bool isSwitch;
  final bool switchValue;
  final VoidCallback? onAddDevice;
  final ValueChanged<bool>? onSwitchChanged;
  final bool isicon;
  final Color bgColor;

  const DeviceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.isSwitch = false,
    this.switchValue = false,
    this.onAddDevice,
    this.onSwitchChanged,
    this.isicon = false,
    this.bgColor = Colors.lightBlueAccent,
    Key? key,
  }) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.switchValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: widget.isicon || widget.title.isNotEmpty || widget.subtitle.isNotEmpty || widget.isSwitch
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
        children: [
          if (widget.isicon)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns icon and switch to the top
              children: [
                Icon(widget.icon, size: 35.0),
                Spacer(), // Adds spacing between icon and switch
                if (widget.isSwitch)
                  Switch(
                    value: _switchValue,
                    onChanged: (bool value) {
                      setState(() {
                        _switchValue = value;
                      });
                      if (widget.onSwitchChanged != null) {
                        widget.onSwitchChanged!(value);
                      }
                    },
                  )
                else
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
              ],
            ),
          SizedBox(height: 15.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ),
          if (widget.subtitle.isNotEmpty) ...[
            SizedBox(height: 15.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.subtitle,
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ],
      )
          : Center(
        child: IconButton(
          icon: Icon(Icons.add, size: 50.0),
          onPressed: widget.onAddDevice,
        ),
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
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
