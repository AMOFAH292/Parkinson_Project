import 'package:flutter/material.dart';

// --- Helper Widget for the Gait Pattern Chart Placeholder ---
class GaitPatternChartPlaceholder extends StatelessWidget {
  const GaitPatternChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // This container simulates the chart area
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
        children: [
          const Text(
            'Overall Gait Symmetry',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            '92%',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Text(
            'Excellent Stability',
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your gait shows excellent balance and consistency between steps.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Gait Pattern Over Time Title
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gait Pattern Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Placeholder for the Line Graph
          Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
                left: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.network(
                // Placeholder image URL to simulate a line graph
                'https://placehold.co/400x120/E0E0E0/333333?text=Gait+Graph+Simulation',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Text('Graph Loading Error', style: TextStyle(color: Colors.red))),
              ),
            ),
          ),
          // X-axis labels (simplified)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('5', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('10', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Left Foot Impact', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('Right Foot Impact', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN GAIT TEST SCREEN
// -----------------------------------------------------------------------------

class GaitTestScreen extends StatelessWidget {
  const GaitTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For this mock, we'll display the results section by default.
    bool isTestRunning = true; // Set to false to hide 'Steps Taken' and show 'Retake'

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Gait Test',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.5),
            width: 0.6,
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Test Instructions Card
              _buildSectionCard(
                context,
                title: 'How to Perform the Gait Test',
                icon: Icons.directions_walk,
                content: Column(
                  children: [
                    const Text(
                      'Follow these steps to ensure an accurate gait analysis.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildInstructionPoint(
                        'Place your phone securely in your front or back pocket.'),
                    _buildInstructionPoint(
                        'Ensure the screen is locked to avoid accidental touches.'),
                    _buildInstructionPoint(
                        'Walk naturally for at least 30 seconds in a straight line.'),
                    _buildInstructionPoint(
                        'Avoid stopping or changing direction abruptly during the test.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Live Tracking Card (Conditional)
              if (isTestRunning) ...[
                _buildSectionCard(
                  context,
                  title: 'Live Tracking',
                  icon: Icons.timeline,
                  content: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '128',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              'Steps taken',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text('Visualizing motion in real-time...',
                                style: TextStyle(fontSize: 16, color: Colors.grey)),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Detecting Stable Pattern',
                                style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Results Card
              _buildSectionCard(
                context,
                title: 'Test Results',
                icon: Icons.bar_chart,
                content: const GaitPatternChartPlaceholder(),
              ),
              const SizedBox(height: 24),

              // Analytical Insights Card
              _buildSectionCard(
                context,
                title: 'Analytical Insights',
                icon: Icons.lightbulb_outline,
                content: _buildAnalyticalInsights(context),
              ),
              const SizedBox(height: 24),

              // Retake Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement retake gait test logic
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
                    'Retake Gait Test',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for section cards
  Widget _buildSectionCard(BuildContext context,
      {required String title, required IconData icon, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 28),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  // Helper for instruction bullet points
  Widget _buildInstructionPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(Icons.circle, size: 6, color: Colors.black54),
          ),
          const SizedBox(width: 10),
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

  // Helper for Analytical Insights Card
  Widget _buildAnalyticalInsights(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Analytical Insights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildInsightPoint(
              'Your gait analysis indicates strong stability but slight variations in Right-Foot impact.'),
          _buildInsightPoint(
              'Focus on maintaining consistent arm swing.'),
          _buildInsightPoint(
              'Ensure a clear, open path during the test.'),
          _buildInsightPoint(
              'Consider performing the test on different surfaces for varied insights.'),
        ],
      ),
    );
  }

  // Helper for insight bullet points
  Widget _buildInsightPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(Icons.circle, size: 6, color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}