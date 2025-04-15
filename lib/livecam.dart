import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class LiveCamView extends StatefulWidget {
  const LiveCamView({super.key});

  @override
  State<LiveCamView> createState() => _LiveCamViewState();
}

class _LiveCamViewState extends State<LiveCamView> {
  late VlcPlayerController _vlcController;
  int workersFound = 0;
  int ppeCompliance = 0;
  int ppeNonCompliance = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _vlcController = VlcPlayerController.network(
      'http://192.168.1.27:8000/stream',
      autoPlay: true,
      hwAcc: HwAcc.full,
      options: VlcPlayerOptions(),
    );
    fetchStats();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) => fetchStats());
  }

  Future<void> fetchStats() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.27:5000/api/stats'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          workersFound = data['total_workers_detected'] ?? 0;
          ppeCompliance = data['workers_complied'] ?? 0;
          ppeNonCompliance = data['workers_noncompliant'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching stats: $e');
    }
  }

  @override
  void dispose() {
    _vlcController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Veiw',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.blueGrey[300],
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Shrink to fit content
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9, // Maintain proper video ratio
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: VlcPlayer(
                        aspectRatio: 16 / 9,
                        controller: _vlcController,
                        placeholder: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Workers Found: $workersFound',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Compliant: $ppeCompliance',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Non-compliant: $ppeNonCompliance',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: fetchStats,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Capture Report',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
