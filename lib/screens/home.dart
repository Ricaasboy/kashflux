import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KashFlux"),
      ),

      drawer: const Sidebar(),

      body: const Center(
        child: Text("Home"),
      ),
    );
  }
}