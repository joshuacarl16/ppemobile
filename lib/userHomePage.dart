import 'package:flutter/material.dart';
import 'package:flutter_application_1/livecam.dart';
import 'package:flutter_application_1/complianceReports.dart';
import 'package:flutter_application_1/reportsHistory.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    String? deviceID;
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceID = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceID = iosInfo.identifierForVendor;
      }
    } catch (e) {
      print("Error getting device ID: $e");
    }

    if (deviceID != null) {
      try {
        final url = "http://192.168.1.27:5000/api/devices/$deviceID";
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            userName = data['name'] ?? 'Unknown';
          });
        } else {
          print("Failed to fetch user: ${response.statusCode}");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $userName',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
              const Text(
                'Safety Officer',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
          backgroundColor: Colors.grey[300],
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                print('Notifications icon tapped');
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.settings_outlined, color: Colors.black),
            //   onPressed: () {
            //     print('Settings icon tapped');
            //   },
            // ),
          ],
        ),
        backgroundColor: Colors.blueGrey[200],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildMenuButton(
                  icon: Icons.videocam,
                  label: 'Live Camera',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LiveCamView()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  icon: Icons.note_alt_outlined,
                  label: 'Reports',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ComplianceReportsScreen()),
                    );
                  },
                ),
                // const SizedBox(height: 20),
                // _buildMenuButton(
                //   icon: Icons.history,
                //   label: 'History',
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => HistorScreen()),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 250,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
