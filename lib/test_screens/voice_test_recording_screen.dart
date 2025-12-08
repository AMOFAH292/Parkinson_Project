import 'package:flutter/material.dart';

class VoiceTestRecordingScreen extends StatelessWidget {
  final int recordingDuration;
  final List<double> waveformData;
  final String text;
  final bool isPaused;
  final VoidCallback onPauseResume;
  final VoidCallback onStopTest;

  const VoiceTestRecordingScreen({
    super.key,
    required this.recordingDuration,
    required this.waveformData,
    required this.text,
    required this.isPaused,
    required this.onPauseResume,
    required this.onStopTest,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey.shade50, // Light background like other screens
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Timer Card
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${recordingDuration ~/ 60}:${(recordingDuration % 60).toString().padLeft(2, '0')} / 2:00',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Waveform Card
                Container(
                  height: 150,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: WaveformPainter(waveformData),
                    child: Container(),
                  ),
                ),
                const SizedBox(height: 20),
                // Text Container
                Container(
                  height: 450,
                  width: double.infinity,
                  //color: const Color.fromARGB(255, 226, 233, 238), // Match background
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.left,
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
        // Floating Buttons Column
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                onPressed: onPauseResume,
                backgroundColor: (isPaused ? Colors.green : Colors.orange).withOpacity(0.9),
                foregroundColor: Colors.white,
                icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                label: Text(isPaused ? 'Resume' : 'Pause'),
              ),
              const SizedBox(height: 16),
              FloatingActionButton.extended(
                onPressed: onStopTest,
                backgroundColor: Colors.red.withOpacity(0.9),
                foregroundColor: Colors.white,
                icon: const Icon(Icons.stop),
                label: const Text('Analyze'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> data;

  WaveformPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    final barWidth = size.width / data.length;
    for (int i = 0; i < data.length; i++) {
      final height = (data[i].abs() + 0.1) * size.height / 1.2;
      final rect = Rect.fromLTWH(i * barWidth, size.height - height, barWidth - 2, height);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}