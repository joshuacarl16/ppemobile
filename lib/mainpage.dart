import 'package:flutter/material.dart';
import 'package:flutter_application_1/qrscreen.dart';
import 'package:flutter_application_1/homepage.dart';
import 'package:flutter_application_1/userHomePage.dart';
import 'package:flutter_application_1/waitingRegister.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? deviceID;
  bool isLoading = false;

  Future<void> getDeviceID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String id = "Unknown Device ID";

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        id = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        id = iosInfo.identifierForVendor ?? "Unknown iOS Device";
      }
    } catch (e) {
      print("Error getting device ID: $e");
    }

    setState(() {
      deviceID = id;
    });
  }

  Future<void> checkDeviceStatus() async {
    if (deviceID == null) {
      print("Device ID not found");
      return;
    }

    setState(() {
      isLoading = true;
    });

    String apiUrl = "http://192.168.1.27:5000/api/devices/$deviceID";

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["registered"] == true) {
          if (data["admin"] == true) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UserHomePage()));
          }
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => WaitingRegisterPage()));
        }
      } else if (response.statusCode == 404) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => QrPage()));
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching device status: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceID();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[400],
          centerTitle: true,
        ),
        backgroundColor: Colors.blueGrey[300],
        body: Center(
          child: Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PPE Compliance Monitor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: checkDeviceStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
