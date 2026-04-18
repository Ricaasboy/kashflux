import 'package:flutter/material.dart';
import 'screens/home.dart';
// import 'screens/add_screen.dart';

void main() {
  runApp(const KashFluxApp());
}

class KashFluxApp extends StatelessWidget {
  const KashFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // página inicial
      initialRoute: '/',

      // todas as rotas da app
      routes: {
        '/': (context) => const Home(),
        // '/add': (context) => const AddScreen(),
      },
    );
  }
}