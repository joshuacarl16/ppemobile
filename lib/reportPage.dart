import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class ReportPage extends StatelessWidget {
  final Map<String, dynamic>? report;

  const ReportPage({super.key, required this.report});

  void downloadReport(BuildContext context, List<dynamic> reportsList, String dateTimestamp, String hourTimestamp) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required to save the file.")),
      );
      return;
    }

    // 🔍 Step 1: Get Device ID
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
      print("Error retrieving device ID: $e");
    }

    // 🔍 Step 2: Fetch user info from the server
    String reportedBy = "Unknown User";
    if (deviceID != null) {
      try {
        final url = "http://192.168.1.27:5000/api/devices/$deviceID";
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          if (userData["name"] != null) {
            reportedBy = userData["name"];
          }
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }

    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.name = "PPE Report";

    final titleCell = sheet.getRangeByName('A1');
    titleCell.setText('Compliance Report');
    titleCell.cellStyle.bold = true;
    titleCell.cellStyle.fontSize = 20;

    sheet.getRangeByName('A2').setText('Project Site:');
    sheet.getRangeByName('B2').setText('USJR Quadricentennial Building');
    sheet.getRangeByName('A3').setText('Date:');
    sheet.getRangeByName('B3').setText('$dateTimestamp $hourTimestamp');
    sheet.getRangeByName('A4').setText('Location:');
    sheet.getRangeByName('B4').setText('5th Floor');

    final headers = ["Worker Name", "Worker Role", "Severity Level", "Detected Gear", "Missing Gear", "Image"];
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(5, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
    }

    // Fill table data
    int currentRow = 6;
    for (var report in reportsList) {
      sheet.getRangeByIndex(currentRow, 1).setText(report['worker_name'] ?? 'N/A');
      sheet.getRangeByIndex(currentRow, 2).setText(report['worker_role'] ?? 'N/A');
      sheet.getRangeByIndex(currentRow, 3).setText(report['severity_level'] ?? 'N/A');
      sheet.getRangeByIndex(currentRow, 4).setText((report['detected_gear'] ?? []).join(', '));
      sheet.getRangeByIndex(currentRow, 5).setText((report['missing_gear'] ?? []).join(', '));

      final base64Image = report['image'];
      if (base64Image != null && base64Image.isNotEmpty) {
        try {
          final picture = sheet.pictures.addBase64(currentRow, 6, base64Image);
          picture.height = 120;
          picture.width = 160;
          sheet.getRangeByIndex(currentRow, 6).rowHeight = 100;
        } catch (e) {
          print("Error inserting image: $e");
        }
      }

      currentRow++;
    }

    sheet.getRangeByIndex(currentRow + 2, 1).setText('Reported By: $reportedBy');
    sheet.getRangeByIndex(currentRow + 2, 1).cellStyle.bold = true;

    for (int i = 1; i <= 5; i++) {
      sheet.autoFitColumn(i);
    }

    // Save and export file
    final List<int> bytes = workbook.saveAsStream();
    final downloadsDir = Directory('/storage/emulated/0/Download');
    final filePath = '${downloadsDir.path}/Compliance_Report_${DateTime.now()}.xlsx';
    final File file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Report downloaded to: $filePath")),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (report == null || report!['reports'] == null || (report!['reports'] as List).isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(child: Text('No report data available')),
      );
    }

    List<dynamic> reportsList = report!['reports'];
    String dateTimestamp = report!['date'];
    String hourTimestamp = report!['time'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Compliance Reports',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.blueGrey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 208, 209, 209),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Camera Alert',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Noncompliance Found',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => downloadReport(context, reportsList, dateTimestamp, hourTimestamp),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Download Report'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: reportsList.map((reportData) {
                  String workerName = reportData['worker_name'] ?? 'Unknown';
                  String workerRole = reportData['worker_role'] ?? 'Unknown';
                  String severityLevel = reportData['severity_level'] ?? 'Unknown';
                  List<String> detectedGear = List<String>.from(reportData['detected_gear'] ?? []);
                  List<String> missingGear = List<String>.from(reportData['missing_gear'] ?? []);
                  String? base64Image = reportData['image']; // Extract base64 image

                  Uint8List? imageBytes;
                  if (base64Image != null && base64Image.isNotEmpty) {
                    try {
                      imageBytes = base64Decode(base64Image);
                    } catch (e) {
                      print("Error decoding base64 image: $e");
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$workerName - $workerRole',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          Text(
                            'Severity Level: $severityLevel',
                            style: const TextStyle(fontSize: 14, color: Colors.red),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            border: TableBorder.all(color: Colors.black),
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(3),
                            },
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(color: Colors.grey),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Detected Gear', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Missing Gear', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(detectedGear.isNotEmpty ? detectedGear.join(', ') : 'None', style: const TextStyle(color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(missingGear.isNotEmpty ? missingGear.join(', ') : 'None', style: const TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Image placement below the table
                          if (imageBytes != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                imageBytes,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[400],
                              child: const Center(child: Icon(Icons.image, size: 50, color: Colors.black)),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
