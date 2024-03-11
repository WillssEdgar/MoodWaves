import 'package:flutter/material.dart';
import 'resources.dart';
import 'dashboard.dart';
import 'events.dart';
import 'journal.dart';
import '/screens/rewards.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    // ResourcesPage(),
    EventsPage(),
    DashboardPage(),
    JournalPage(),
    RewardsPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.teal,
      appBar: AppBar(
        title: const Text(
          'Mood Waves',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.teal, 
        centerTitle: true,
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ), // IndexedStack to maintain state of screens

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Resources',
          ),
                    BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Rewards',
          ),
        ],

        backgroundColor: Colors.black, // BottomNavigationBar background color
        unselectedItemColor: Colors.grey, // Unselected item color
        type:
            BottomNavigationBarType.fixed, 
      ),
    );
  }
}
