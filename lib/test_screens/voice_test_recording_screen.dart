import 'dart:math';

import 'package:flutter/material.dart';


class VoiceTestRecordingScreen extends StatelessWidget {
  final int recordingDuration;
  final String text;
  final bool isPaused;
  final VoidCallback onPauseResume;
  final VoidCallback onStopTest;

  const VoiceTestRecordingScreen({
    super.key,
    required this.recordingDuration,
    required this.text,
    required this.isPaused,
    required this.onPauseResume,
    required this.onStopTest,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// ------------------------------
        /// MAIN SCROLLABLE AREA (FIXED)
        /// ------------------------------
        Container(
          color: Colors.grey.shade50,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          /// ------------------------------
                          /// TIMER CARD
                          /// ------------------------------
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
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// ------------------------------
                          /// WAVEFORM CARD
                          /// ------------------------------
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
child: const SmoothAudioBars(),
                          ),

                          const SizedBox(height: 20),

                          /// ------------------------------
                          /// TEXT READING CARD
                          /// ------------------------------
                          Container(
                            height: 450,
                            width: double.infinity,
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

                          const SizedBox(height: 120), // space for FAB column
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        /// ------------------------------
        /// FLOATING BUTTONS
        /// ------------------------------
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                onPressed: onPauseResume,
                backgroundColor: (isPaused ? Colors.green : Colors.orange)
                    .withOpacity(0.9),
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

class SmoothAudioBars extends StatefulWidget {
  const SmoothAudioBars({super.key});

  @override
  State<SmoothAudioBars> createState() => _SmoothAudioBarsState();
}

class _SmoothAudioBarsState extends State<SmoothAudioBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> baseHeights;

  @override
  void initState() {
    super.initState();

    // Beautiful base pattern – smooth wave-like heights
    baseHeights = List.generate(
      50,
      (i) => 40 + 30 * (1 + sin(i * 0.4)),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          // Shift the bars horizontally by cycling the list
          int shift = (_controller.value * baseHeights.length).floor();
          List<double> shifted = [
            ...baseHeights.sublist(shift),
            ...baseHeights.sublist(0, shift),
          ];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: shifted.map((h) {
              return Container(
                width: 4,
                height: h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF4A90E2),
                      Color(0xFF8E44AD),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
