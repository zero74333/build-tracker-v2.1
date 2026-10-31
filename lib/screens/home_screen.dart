import 'package:flutter/material.dart';

import '../data/database.dart';
import 'dashboard_screen.dart';
import 'export_screen.dart';
import 'history_screen.dart';
import 'insights_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(date: dateKey(DateTime.now())),
      const HistoryScreen(),
      const InsightsScreen(),
      const ExportScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history_rounded), label: 'History'),
          NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Insights'),
          NavigationDestination(icon: Icon(Icons.ios_share_rounded), label: 'Export'),
        ],
      ),
    );
  }
}
