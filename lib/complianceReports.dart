import 'package:flutter/material.dart';

class ComplianceReportsScreen extends StatefulWidget {
  const ComplianceReportsScreen({super.key});

  @override
  State<ComplianceReportsScreen> createState() => _ComplianceReportsScreenState();
}

class _ComplianceReportsScreenState extends State<ComplianceReportsScreen> {
  // Dummy report data (Replace with actual database data later)
  final List<Map<String, String>> reports = [
    {"date": "September 19, 2024", "time": "9:30 AM", "status": "Noncompliance Found"},
    {"date": "September 19, 2024", "time": "9:30 AM", "status": "Noncompliance Found"},
    {"date": "September 19, 2024", "time": "9:30 AM", "status": "Noncompliance Found"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      appBar: AppBar(
        title: const Text(
          'Compliance Report',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              print("Notifications tapped");
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              print("Settings tapped");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            
            // Reports Listconst SizedBox(height: 10),


            Expanded(
              
              child: ListView.builder(
                
                itemCount: reports.length,
                itemBuilder: (context, index) {
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
                      subtitle: Text(reports[index]['status']!,
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
                                Text(reports[index]['date']!,
                                    style: const TextStyle(fontSize: 12, color: Colors.black)),
                                Text(reports[index]['time']!,
                                    style: const TextStyle(fontSize: 12, color: Colors.black)),
                              ],
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_right, size: 30, color: Colors.black),
                              onPressed: () {
                                print("Arrow tapped");
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        print("Report tapped");
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
