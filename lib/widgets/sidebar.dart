import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
            children: [
            Expanded(
                child: ListView(
                padding: EdgeInsets.zero,
                children: [
                    const SizedBox(height: 40),

                    Image.asset(
                    'assets/imgs/complete_logo.png',
                    height: 60,
                    ),

                    ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                        Navigator.pop(context);
                    },
                    ),

                    ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                        Navigator.pop(context);
                    },
                    ),
                ],
                ),
            ),

            const Divider(),

            ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Login'),
                onTap: () {
                Navigator.pop(context);
                },
            ),

            const SizedBox(height: 20),
            ],
        ),
    );
  }
}