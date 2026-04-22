import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      selectedIndex: currentIndex,
      onDestinationSelected: (index) async {
        if (index == currentIndex) return;

        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/operations');
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/profile');
        } else if (index == 3) {
          await SecureStorageService.clearLoginData();

          if (!context.mounted) return;

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Operations',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
        NavigationDestination(
          icon: Icon(Icons.logout_outlined),
          selectedIcon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
    );
  }
}