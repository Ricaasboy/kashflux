import 'package:flutter/material.dart';
import 'screens/auth_check.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/register.dart';

void main() {
  runApp(const KashFluxApp());
}

class KashFluxApp extends StatelessWidget {
  const KashFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthCheck(),
        '/home': (context) => const Home(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
      },
    );
  }
}