import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/livecam.dart';
import 'package:flutter_application_1/registerpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Welcome, ' + 'Neil' + '\nAdministrator User',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey[400],
            actions: [
              IconButton(
                icon: Icon(
                    Icons.notifications_none), // Add your desired icon here
                onPressed: () {
                  // Add functionality for the icon button
                  print('Notifications icon tapped');
                },
              ),
              IconButton(
                icon:
                    Icon(Icons.settings_outlined), // Add your desired icon here
                onPressed: () {
                  // Add functionality for the icon button
                  print('Settings icon tapped');
                },
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey[300],
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveCamView(),
                        ),
                      );
                    },
                    child: Container(
                      height: 130,
                      width: 250,
                      color: Colors.grey[400],
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_camera_front,
                            size: 100,
                          ),
                          Text(
                            'Live Camera',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Add functionality for the icon button
                      print('Reports tapped');
                    },
                    child: Container(
                      height: 130,
                      width: 250,
                      color: Colors.grey[400],
                      child: Column(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 100,
                          ),
                          Text(
                            'Reports',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Add functionality for the icon button
                      print('History tapped');
                    },
                    child: Container(
                      height: 130,
                      width: 250,
                      color: Colors.grey[400],
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: 100,
                          ),
                          Text(
                            'History',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Add functionality for the icon button
                      print('Accounts tapped');
                    },
                    child: Container(
                      height: 130,
                      width: 250,
                      color: Colors.grey[400],
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 100,
                          ),
                          Text(
                            'Accounts',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
