import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_bottom_navigation.dart';
import 'dashboard_screen.dart';
import 'messages_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart'; // <-- ADD THIS
import 'settings_screen.dart';

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({super.key});

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  int _currentNavIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(), // index 0
    const MessagesScreen(), // index 1
    const ChatScreen(), // index 2
    const ProfileScreen(), // index 3
    const SettingsScreen(), // index 4
  ];

  void _onNavTapped(int index) {
    setState(() {
      _currentNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentNavIndex],
      bottomNavigationBar: DashboardBottomNavigation(
        currentIndex: _currentNavIndex,
        onNavTapped: _onNavTapped,
      ),
    );
  }
}
