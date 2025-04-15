import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/livecam.dart';
import 'package:flutter_application_1/registerpage.dart';
import 'package:flutter_application_1/complianceReports.dart';
import 'package:flutter_application_1/reportsHistory.dart';
import 'package:flutter_application_1/devicelist.dart';

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
            title: const Text(
              'Welcome, ' + '\nAdministrator User',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey[400],
            actions: [
              IconButton(
                icon: const Icon(
                    Icons.notifications_none), // Icon here
                onPressed: () {
                  print('Notifications icon tapped');
                },
              ),
              // IconButton(
              //   icon:
              //       const Icon(Icons.settings_outlined), // Icon here
              //   onPressed: () {
              //     print('Settings icon tapped');
              //   },
              // ),
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
                      child: const Column(
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
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComplianceReportsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 130,
                      width: 250,
                      color: Colors.grey[400],
                      child: const Column(
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
                  // const SizedBox(height: 20),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => HistorScreen(),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     height: 130,
                  //     width: 250,
                  //     color: Colors.grey[400],
                  //     child: const Column(
                  //       children: [
                  //         Icon(
                  //           Icons.history,
                  //           size: 100,
                  //         ),
                  //         Text(
                  //           'History',
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.bold, fontSize: 18),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceListPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 130,
                      width: 250,
                      color: Colors.grey[400],
                      child: const Column(
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
