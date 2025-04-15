import 'package:flutter/material.dart';
import 'package:flutter_application_1/homepage.dart';
import 'package:flutter_application_1/waitingRegister.dart';
import 'package:flutter_application_1/userHomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  String? deviceName;
  String? deviceID;

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String name = "Unknown Device";
    String id = "Unknown Device ID";

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        name = "${androidInfo.brand} ${androidInfo.model}";
        id = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        name = iosInfo.name;
      }
    } catch (e) {
      print("Error getting device info: $e");
    }

    setState(() {
      deviceName = name;
      deviceID = id;
    });

    checkDeviceRegistration(id);
  }

  Future<void> checkDeviceRegistration(String deviceId) async {
    String apiUrl = "http://192.168.1.27:5000/api/devices/$deviceId";

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["registered"] == true) {
          
          if (data["admin"] == true){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          }
          else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomePage()));
          }
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => WaitingRegisterPage()));
        }
      }
    } catch (e) {
      print("Error checking device registration: $e");
    }
  }

  Future<void> registerDevice() async {
    String apiUrl = "http://192.168.1.27:5000/api/devices";

    Map<String, dynamic> data = {
      "device_id": deviceID ?? "Unknown",
      "device_name": deviceName ?? "Unknown",
      "name": nameController.text.trim(),
      "registered": false,
      "admin": false,
      "role": roleController.text.trim()
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Device registered successfully!");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WaitingRegisterPage()));
      } else {
        print("Failed to register device: ${response.body}");
      }
    } catch (e) {
      print("Error registering device: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register Device',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.blueGrey[300],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Center(
              child: Container(
                width: 300,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.black), // Text color
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.black), // Label color
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // Border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // Focused border color
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: roleController,
                      style: TextStyle(color: Colors.black), // Text color
                      decoration: InputDecoration(
                        labelText: 'Work Role',
                        labelStyle: TextStyle(color: Colors.black), // Label color
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // Border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // Focused border color
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: registerDevice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
