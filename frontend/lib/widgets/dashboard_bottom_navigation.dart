import 'package:flutter/material.dart';

class DashboardNavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class DashboardBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavTapped;

  const DashboardBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onNavTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      onTap: onNavTapped,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Messages'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
