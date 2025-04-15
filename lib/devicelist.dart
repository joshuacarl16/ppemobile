import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  List<dynamic> devices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> registerUser(String deviceId) async {
    final url = Uri.parse('http://192.168.1.27:5000/api/devices/$deviceId'); // Adjust API route

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'registered': true}),
      );

      if (response.statusCode == 200) {
        setState(() {
          fetchDevices(); // Refresh device list after registration
        });
      } else {
        print('Failed to register user: ${response.body}');
      }
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  Future<void> deleteUser(String deviceId) async {
    final url = Uri.parse('http://192.168.1.27:5000/api/devices/$deviceId');

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successfully deleted - show snackbar and refresh list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device registration removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Remove the device from the local list immediately
        setState(() {
          devices.removeWhere((device) => device['device_id'] == deviceId);
        });
      } else if (response.statusCode == 404) {
        // Device not found - show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device not found'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Other error - show status code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove device: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        print('Failed to delete device: ${response.body}');
      }
    } catch (e) {
      // Network or other error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing device: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error deleting device: $e');
    }
  }

  Future<void> fetchDevices() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.27:5000/api/devices'));
      if (response.statusCode == 200) {
        setState(() {
          devices = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load devices');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching devices: $e');
    }
  }

  void _showManageDialog(BuildContext context, String deviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Manage Device"),
          content: const Text("Choose an action for this device:"),
          actions: <Widget>[
            TextButton(
              child: const Text("Register Device"),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser(deviceId);
              },
            ),
            TextButton(
              child: const Text("Deny Register", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser(deviceId);
              },
            ),
          ],
        );
      },
    );
  }

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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          var device = devices[index];
                          return _buildDeviceCard(
                            device["device_id"],
                            device["device_name"] ?? "Unknown Device",
                            device["name"] ?? "Unknown Name",
                            device["role"] ?? "Unknown Role",
                            device["registered"] ?? false,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Device List Item Card
  Widget _buildDeviceCard(String deviceId, String title, String username, String role, bool registered) {
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
            // Device and user info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 5),
                Text("User: $username", style: const TextStyle(fontSize: 14, color: Colors.black)),
                Text("Role: $role", style: const TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),

            // Register User Button (Only if not already registered)
            if (!registered)
              ElevatedButton(
                onPressed: () => _showManageDialog(context, deviceId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Manage', style: TextStyle(color: Colors.black)),
              ),
          ],
        ),
      ),
    );
  }
}