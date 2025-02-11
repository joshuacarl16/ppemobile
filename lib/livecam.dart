// https://scontent.xx.fbcdn.net/v/t1.15752-9/466167738_1260234895096038_6301843406910092136_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=0024fc&_nc_ohc=IiWrRAdjcFIQ7kNvgEjFMfK&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1gF3JV6SHe-Zq8w6kypOx8omEiddDLkN_5g6JSD4vvey6g&oe=6794D852

import 'package:flutter/material.dart';
import 'package:flutter_application_1/devicelist.dart';
import 'package:flutter_application_1/homepage.dart';

class LiveCamView extends StatefulWidget {
  const LiveCamView({super.key});

  @override
  State<LiveCamView> createState() => _LiveCamViewState();
}

class _LiveCamViewState extends State<LiveCamView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('LIVE CAM VIEW',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey[400], // Customize AppBar color
          centerTitle: true, // Center the title
        ),
        backgroundColor: Colors.blueGrey[300],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 300,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 250,
                          width: 300,
                          child: Image.asset(
                            'assets/test2.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          children: [Text('Workers Found: \n' + '69')],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('PPE Compliance: \n' + '69'),
                            Text('PPE Noncompliance: \n' + '69')
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.pop(
                                //     context); // Navigate to the previous screen
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[500],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Capture Report',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ],
                        )
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
}
