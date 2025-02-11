import 'package:flutter/material.dart';
import 'package:flutter_application_1/registerpage.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'DEVICE LIST',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.grey[400],
          actions: [
            IconButton(
              icon:
                  Icon(Icons.notifications_none), // Add your desired icon here
              onPressed: () {
                // Add functionality for the icon button
                print('Notifications icon tapped');
              },
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined), // Add your desired icon here
              onPressed: () {
                // Add functionality for the icon button
                print('Settings icon tapped');
              },
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey[300],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate to the previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios_new, color: Colors.black),
                          SizedBox(width: 5),
                          Text(
                            'Back',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate to the previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 5),
                          Text(
                            'Show Register QR Code',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 360,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildListItem(
                            "New Device", "User name", "Device name"),
                        _buildListItem(
                            "Registered Device", "User name", "Device name"),
                        _buildListItem(
                            "New Device", "User name", "Device name"),
                        _buildListItem(
                            "Registered Device", "User name", "Device name"),
                        _buildListItem(
                            "Registered Device", "User name", "Device name"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A function to generate the list item box
  Widget _buildListItem(String title, String username, String devicename) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: 360,
        height: 80,
        padding: const EdgeInsets.only(left: 6.0, top: 4.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // This will place items on both sides
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(username),
                Text(devicename),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                ),
                child: Text(
                  'Register Device',
                  style: TextStyle(color: Colors.black),
                ), // Customize the text of the button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
