import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'reportPage.dart';
import 'dart:async';

class ComplianceReportsScreen extends StatefulWidget {
  const ComplianceReportsScreen({super.key});

  @override
  State<ComplianceReportsScreen> createState() => _ComplianceReportsScreenState();
}

class _ComplianceReportsScreenState extends State<ComplianceReportsScreen> {
  
  DateTime? lastCheckedTimestamp = DateTime.now();
  List<Map<String, dynamic>> allReports = [];
  List<Map<String, dynamic>> filteredReports = [];

  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    fetchReports();

  }

  
  Future<void> fetchReports() async {
    final url = Uri.parse('http://192.168.1.27:5000/api/events');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> extractedEvents = [];

        for (var event in data) {
          DateTime timestamp = DateTime.parse(event["timestamp"]).toLocal();  // Key fix
          String formattedDate = "${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}";
          String formattedTime = "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.hour >= 12 ? 'PM' : 'AM'}";

          extractedEvents.add({
            "date": formattedDate,
            "time": formattedTime,
            "status": "Noncompliance Found",
            "reports": event["reports"],
            "timestamp": timestamp.toString(),
          });
        }

        // Sort by latest first
        extractedEvents.sort((a, b) => DateTime.parse(b["timestamp"]).compareTo(DateTime.parse(a["timestamp"])));

        setState(() {
          allReports = extractedEvents;
          filteredReports = extractedEvents;
        });

        print("Extracted events: $allReports");
      } else {
        print("Failed to load reports: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching reports: $error");
    }
  }

  void filterByDateRange(DateTimeRange? range) {
    if (range == null) return;

    final filtered = allReports.where((report) {
      final timestamp = DateTime.parse(report['timestamp']);
      return timestamp.isAfter(range.start.subtract(const Duration(days: 1))) &&
             timestamp.isBefore(range.end.add(const Duration(days: 1)));
    }).toList();

    setState(() {
      selectedDateRange = range;
      filteredReports = filtered;
    });
  }

  Future<void> pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: selectedDateRange,
    );
    if (picked != null) {
      filterByDateRange(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      appBar: AppBar(
        title: const Text(
          'Compliance Report',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 190, 190, 190),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () => print("Notifications tapped"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: allReports.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedDateRange = null;
                            filteredReports = allReports;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                      ),
                      ElevatedButton.icon(
                        onPressed: pickDateRange,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          selectedDateRange == null
                              ? 'Filter by Date'
                              : '${selectedDateRange!.start.month}/${selectedDateRange!.start.day}/${selectedDateRange!.start.year} - '
                                '${selectedDateRange!.end.month}/${selectedDateRange!.end.day}/${selectedDateRange!.end.year}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredReports.length,
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.grey[200],
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            title: const Text(
                              'Camera Alert',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            subtitle: Text(report['status'],
                                style: const TextStyle(fontSize: 12, color: Colors.black)),
                            trailing: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(report['date'],
                                          style: const TextStyle(fontSize: 12, color: Colors.black)),
                                      Text(report['time'],
                                          style: const TextStyle(fontSize: 12, color: Colors.black)),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.keyboard_arrow_right, size: 30, color: Colors.black),
                                    onPressed: () => print("Arrow tapped"),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportPage(report: report),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
