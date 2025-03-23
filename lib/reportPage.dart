import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Compliance Report',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              // Alert Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Camera Alert',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Noncompliance Found',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[400],
                      child: const Center(child: Icon(Icons.image, size: 50, color: Colors.black)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Footage Report',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(4),
                      },
                      children: const [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Worker Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Worker's Designation", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Compliance Risk Level', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('PPE Set', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('John Doe', style: TextStyle(color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Carpenter', style: TextStyle(color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Safe', style: TextStyle(color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Hard Hat, Safety Goggles, Worker Boots', style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('John Doe', style: TextStyle(color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Carpenter', style: TextStyle(color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Low', style: TextStyle(color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Hard Hat, Safety Goggles, Worker Boots', style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            'Download Report',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
