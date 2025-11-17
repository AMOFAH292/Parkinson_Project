import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Mock data to populate the history list
  static final List<TestResult> _mockHistoryData = [
    TestResult('Voice Test', 'Oct 28, 2025', 'Stable', Colors.green.shade700, Icons.mic),
    TestResult('Tremor Test', 'Oct 28, 2025', 'Needs Review', Colors.orange.shade700, Icons.trending_up),
    TestResult('Gait Test', 'Oct 25, 2025', 'Minor Fluctuation', Colors.amber.shade700, Icons.directions_walk),
    TestResult('Voice Test', 'Sep 15, 2025', 'Stable', Colors.green.shade700, Icons.mic),
    TestResult('Tremor Test', 'Sep 01, 2025', 'Stable', Colors.green.shade700, Icons.trending_down),
    TestResult('Gait Test', 'Aug 10, 2025', 'Stable', Colors.green.shade700, Icons.directions_walk),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Test History',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.black),
            onPressed: () {}, // Placeholder for sorting action
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Recent Activity',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Review results from your latest health assessments.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Displaying the list of mock data
            ..._mockHistoryData.map((result) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: HistoryCard(result: result),
              );
            }).toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final TestResult result;

  const HistoryCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Test Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  result.icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Test Name and Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.testName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Result Status and Arrow
          Row(
            children: [
              Text(
                result.result,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: result.resultColor,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TestResult {
  final String testName;
  final String date;
  final String result;
  final Color resultColor;
  final IconData icon;

  TestResult(this.testName, this.date, this.result, this.resultColor, this.icon);
}

class LowRiskCard extends StatelessWidget {
  const LowRiskCard({super.key});

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkmark Icon
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).primaryColor, // Use app primary color
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Low Risk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                // Highlighted text to match the image's purple box/highlight
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Based on your recent tests, your health indicators '),
                      TextSpan(
                        text: 'are stable.',
                        style: TextStyle(
                          color: const Color(0xFF8E24AA), // Deep purple color
                          fontWeight: FontWeight.w600,
                          backgroundColor:
                              const Color(0xFFE1BEE7).withOpacity(0.5), // Light purple background
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}