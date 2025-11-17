import 'package:flutter/material.dart';
import 'package:park_ai/main_pages/explore.dart';
import 'package:park_ai/main_pages/home.dart';
import 'package:park_ai/main_pages/history.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    HistoryScreen(),
    ExploreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The Scaffold holds the current screen and the Bottom Navigation Bar
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _screens.elementAt(_selectedIndex),
      // The Navbar component is implemented here as BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor, // Active color
        unselectedItemColor: Colors.grey.shade600, // Inactive color
        onTap: _onItemTapped,
        showUnselectedLabels: true, // Show all labels
        type: BottomNavigationBarType.fixed, // Fixed layout
      ),
    );
  }
}
