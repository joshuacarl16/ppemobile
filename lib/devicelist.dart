import 'package:flutter/material.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: const Text(
          'Device List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              print('Notifications icon tapped');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              print('Settings icon tapped');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Top Section (Back Button & QR Code Button)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),

                  // Show Register QR Code Button
                  ElevatedButton(
                    onPressed: () {
                      print("Show QR Code Button Pressed");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    child: const Text(
                      'Show register QR Code',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Device List Container
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView(
                  children: [
                    _buildDeviceCard("New Device", "User Name", "Device Name", true),
                    _buildDeviceCard("Registered Device", "User Name", "Device Name", false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Device List Item Card
  Widget _buildDeviceCard(String title, String username, String devicename, bool showButton) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Device Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),

                const SizedBox(height: 5),
                Text(username, style: const TextStyle(fontSize: 14, color: Colors.black)),
                Text(devicename, style: const TextStyle(fontSize: 14, color: Colors.black)),

              ],
            ),

            // Register Device Button (Only for "New Device")
            if (showButton)
              ElevatedButton(
                onPressed: () {
                  print("Register Device Pressed");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                ),
                child: const Text(
                  'Register Device',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
