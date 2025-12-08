import 'package:flutter/material.dart';

class VoiceTestInitialScreen extends StatelessWidget {
  final VoidCallback onStartTest;

  const VoiceTestInitialScreen({super.key, required this.onStartTest});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.mic,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 40),
          const Text(
            'Voice Test Instructions',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Read the provided text aloud while recording. The text will scroll automatically; you can manually drag it back or forward. Recording is limited to 2 minutes.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onStartTest,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              textStyle: const TextStyle(fontSize: 20),
            ),
            child: const Text('Start Test'),
          ),
        ],
      ),
    );
  }
}