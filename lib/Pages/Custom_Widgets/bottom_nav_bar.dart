import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFFFFFF),
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFFFFB900),
      unselectedItemColor: const Color(0xFF5A6980),
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 28),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.car_rental, size: 28),
          label: 'Posted Booking',
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.add_circle,
            size: 48,
            color: Color(0xFFFFB900),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat, size: 28),
          label: 'Chat',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 28),
          label: 'Profile',
        ),
      ],
    );
  }
}
