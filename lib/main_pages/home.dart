import 'package:flutter/material.dart';
import 'package:park_ai/test_screens/gait_test_screen.dart';
import 'package:park_ai/test_screens/tremor_test_screen.dart';
import 'package:park_ai/test_screens/voice_test_screen.dart';

// -----------------------------------------------------------------------------
// 1. HOME SCREEN (Replicates the detailed UI)
// -----------------------------------------------------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        // Left side: Grid and Heart icons
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.grid_view_rounded, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // Right side: Search and More icons
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header Text
            const Text(
              'Hello, Sarah!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your health overview at a glance.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Low Risk Card
            const LowRiskCard(),
            const SizedBox(height: 20),

            // Test Cards - Now with navigation
            TestCard(
              icon: Icons.mic_none,
              title: 'Voice Test',
              description: 'Assess vocal health and identify potential changes.',
              destinationScreen: const VoiceTestScreen(), // Navigate to Voice Test
            ),
            const SizedBox(height: 16),
            TestCard(
              icon: Icons.network_check,
              title: 'Tremor Test',
              description: 'Measure hand steadiness and detect subtle tremors.',
              destinationScreen: const TremorTestScreen(), // Navigate to Tremor Test
            ),
            const SizedBox(height: 16),
            TestCard(
              icon: Icons.accessibility_new,
              title: 'Gait Test',
              description: 'Analyze walking patterns and balance for mobility.',
              destinationScreen: const GaitTestScreen(), // Navigate to Gait Test
            ),
            const SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2), // Bright Blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Test History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1976D2),
                  side: const BorderSide(
                      color: Color(0xFF1976D2), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Health Tips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CUSTOM WIDGETS
// -----------------------------------------------------------------------------

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

class TestCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget destinationScreen; // New property for navigation

  const TestCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.destinationScreen, // Required in constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrap with GestureDetector to handle tap
      onTap: () {
        // Navigate to the specified destination screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Container(
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
            // Icon Container (Stylized circle)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50, // Very light blue background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
            // Add a small arrow to indicate navigability
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}