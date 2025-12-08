import 'package:flutter/material.dart';

class VoiceTestAnalysisScreen extends StatelessWidget {
  final String? result;
  final double clarity;
  final double volume;
  final double pitch;
  final VoidCallback onPlayRecording;
  final VoidCallback onRetakeTest;
  final VoidCallback onExportResults;

  const VoiceTestAnalysisScreen({
    super.key,
    required this.result,
    required this.clarity,
    required this.volume,
    required this.pitch,
    required this.onPlayRecording,
    required this.onRetakeTest,
    required this.onExportResults,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onPlayRecording,
                child: const Text('Replay'),
              ),
              ElevatedButton(
                onPressed: onRetakeTest,
                child: const Text('Retake Test'),
              ),
              ElevatedButton(
                onPressed: onExportResults,
                child: const Text('Export'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (result != null) ...[
            _buildResultCard(result!),
          ],
          const SizedBox(height: 20),
          // Speech Quality Breakdown
          const Text('Speech Quality Breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetricBox('Clarity', clarity.toStringAsFixed(2), Colors.green),
              _buildMetricBox('Volume', volume.toStringAsFixed(2), Colors.blue),
              _buildMetricBox('Pitch', '${pitch.toStringAsFixed(0)} Hz', Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          // Interpretations
          const Text('Interpretations:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildInterpretationCard(
            icon: Icons.check_circle,
            title: 'Clarity Score: ${clarity.toStringAsFixed(2)}',
            description: 'Indicates pronunciation clarity. Scores above 0.7 suggest clear speech.',
            color: Colors.green,
          ),
          const SizedBox(height: 10),
          _buildInterpretationCard(
            icon: Icons.volume_up,
            title: 'Volume Level: ${volume.toStringAsFixed(2)}',
            description: 'Measures loudness. Optimal range is 0.3-0.7 for clear recording.',
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          _buildInterpretationCard(
            icon: Icons.tune,
            title: 'Pitch Frequency: ${pitch.toStringAsFixed(0)} Hz',
            description: 'Average fundamental frequency. Variations may indicate speech patterns.',
            color: Colors.orange,
          ),
          const SizedBox(height: 20),
          // Buttons
         
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    IconData icon;
    if (label == 'Clarity') {
      icon = Icons.check_circle;
    } else if (label == 'Volume') {
      icon = Icons.volume_up;
    } else {
      icon = Icons.tune;
    }

    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.zero, // squared
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String resultText) {
    // Check if it's the final result or intermediate message
    if (!resultText.contains(':')) {
      return Container(
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
        child: Center(
          child: Text(
            resultText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Parse the result text
    final lines = resultText.split('\n');
    String overallClass = lines.isNotEmpty && lines[0].contains(': ') ? lines[0].split(': ')[1] : '';
    String parkinsonSegments = lines.length > 1 && lines[1].contains(': ') ? lines[1].split(': ')[1] : '';
    String confidence = lines.length > 2 && lines[2].contains(': ') ? lines[2].split(': ')[1] : '';

    return Container(
      width: double.infinity,
      height: 203, // Make it taller, square-ish
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildResultItem(Icons.category, 'Overall Class', overallClass, Colors.blue),
              const SizedBox(width: 16),
              _buildResultItem(Icons.timeline, 'Parkinson Segments', parkinsonSegments, Colors.red),
              const SizedBox(width: 16),
              _buildResultItem(Icons.verified, 'Confidence', confidence, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
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
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}