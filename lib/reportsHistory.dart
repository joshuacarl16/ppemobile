import 'package:flutter/material.dart';

class HistorScreen extends StatefulWidget {
  const HistorScreen({super.key});

  @override
  State<HistorScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<HistorScreen> {
  // Dummy data for now (Replace with actual reports from database later)
  final List<Map<String, String>> reports = [
    {"date": "September 19, 2024 | 9:30 AM", "status": "Compliance Report"},
    {"date": "September 19, 2024 | 9:30 AM", "status": "Compliance Report"},
    {"date": "September 19, 2024 | 9:30 AM", "status": "Compliance Report"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      appBar: AppBar(
        title: Text(
          'History Reports',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          
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
        ]
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(height: 16),

            // Reports List
            Expanded(
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.grey[200],
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(reports[index]['date']!,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      subtitle: Text(reports[index]['status']!,
                          style: TextStyle(fontSize: 12, color: Colors.black)),
                          
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.download, size: 20, color: Colors.black),
                            onPressed: () {
                              print("Download tapped");
                              
                              // Show a snackbar to confirm UI is responsive
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("File Downloaded"))
                              );
                            },
                          ),

                        ],
                      ),
                      onTap: () {
                        // TODO: Implement report download functionality
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
