import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class LiveCamView extends StatefulWidget {
  const LiveCamView({super.key});

  @override
  State<LiveCamView> createState() => _LiveCamViewState();
}

class _LiveCamViewState extends State<LiveCamView> {
  late VlcPlayerController _vlcController;

  @override
  void initState() {
    super.initState();
    _vlcController = VlcPlayerController.network(
      'http://192.168.1.22:8000/stream',
      autoPlay: true,
      hwAcc: HwAcc.full,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _vlcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'LIVE CAM VIEW',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.grey[400],
          centerTitle: true,
        ),
        backgroundColor: Colors.blueGrey[300],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
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
                        SizedBox(
                          height: 250,
                          width: 300,
                          child: VlcPlayer(
                            controller: _vlcController,
                            aspectRatio: 16 / 9,
                            placeholder: const Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Row(
                          children: [Text('Workers Found: \n69')],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('PPE Compliance: \n69'),
                            Text('PPE Noncompliance: \n69')
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
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