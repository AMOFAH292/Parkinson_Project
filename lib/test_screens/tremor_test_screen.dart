import 'package:flutter/material.dart';

// --- Helper Widget for the Live Tracking Chart Placeholder ---
class LiveTrackingChartPlaceholder extends StatelessWidget {
  const LiveTrackingChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // This container simulates the chart area and axes
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for the main line graph area (using a simple colored box)
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              // We can't draw the complex lines easily here, so we'll use a gradient
              // or color to represent the data area.
            ),
            alignment: Alignment.center,
            child: const Text(
              'Live Graph Simulation',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _LegendItem(color: Colors.blue, label: 'X-axis'),
              _LegendItem(color: Colors.green, label: 'Y-axis'),
              _LegendItem(color: Colors.red, label: 'Z-axis'),
            ],
          ),
          const SizedBox(height: 20),
          // Calibrate Sensor Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2196F3),
                side: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Calibrate Sensor',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// --- Helper Widget for the Results Bar Chart Placeholder ---
class ResultsBarChartPlaceholder extends StatelessWidget {
  const ResultsBarChartPlaceholder({super.key});

  // Mock data representing the bar lengths (0-1)
  static const double mildHeight = 0.5;
  static const double moderateHeight = 0.8;
  static const double severeHeight = 0.3;
  static const double barWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            'Your Results',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your recent tremor assessment shows a moderate tremor. Consistent monitoring is recommended.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '5.5',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Tremor Severity Score',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 30),
          // Bar Chart Simulation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Bar(
                label: 'Mild',
                percentage: mildHeight,
                color: Colors.blue,
                width: barWidth,
              ),
              _Bar(
                label: 'Moderate',
                percentage: moderateHeight,
                color: Colors.green,
                width: barWidth,
              ),
              _Bar(
                label: 'Severe',
                percentage: severeHeight,
                color: Colors.red,
                width: barWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double percentage; // 0.0 to 1.0
  final Color color;
  final double width;

  const _Bar({
    required this.label,
    required this.percentage,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            height: 150 * percentage, // Max height 150
            width: width * 0.25, // Bar width
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN TREMOR TEST SCREEN
// -----------------------------------------------------------------------------

class TremorTestScreen extends StatelessWidget {
  const TremorTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine which mode to display: Instructions/Tracking or Results
    // For this static mock, we'll display everything, but in a real app,
    // this would be conditional based on `testStatus`.
    bool isTestComplete =
        true; // Set to false to see instructions/tracking only

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tremor Test',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTestComplete) ...[
              const SizedBox(height: 16),
              const Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Follow these steps carefully for an accurate tremor assessment.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              //const SizedBox(height: 20),
              // Placeholder for Hand Image (using a descriptive text box)
              Center(
                
                  child: Image.asset(
                    'assets/images/hold_phone2.png',
                    //height: 300,
                    //width: 300,
                  ),
                ),
              
              const SizedBox(height: 20),
              // Step-by-step instructions
              _buildInstructionStep(
                1,
                'Place your phone flat on the palm of your dominant hand, screen facing up.',
              ),
              _buildInstructionStep(
                2,
                'Keep your hand steady and arm extended forward, parallel to the ground.',
              ),
              _buildInstructionStep(
                3,
                'Ensure your environment is quiet and free from vibrations.',
              ),
              const SizedBox(height: 32),

              // Start Test Button (for instructions screen)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement start test logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Start Test',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Spacing before Live Tracking
            ],

            // Live Tracking Section
            if (isTestComplete) ...[const SizedBox(height: 20)],
            const Text(
              'Live Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const LiveTrackingChartPlaceholder(), // Placeholder widget
            const SizedBox(height: 40),

            // Results Section
            if (isTestComplete) ...[
              const ResultsBarChartPlaceholder(), // Placeholder widget
              const SizedBox(height: 40),
              // Retake Test Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement retake test logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Retake Test',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
