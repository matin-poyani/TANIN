import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF0D0D0D),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.radio),
          label: 'Radio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
    );
  }
}
