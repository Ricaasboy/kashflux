import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';
import 'home.dart';
import 'login.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool? _hasToken;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await SecureStorageService.getToken();

    setState(() {
      _hasToken = token != null && token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasToken == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasToken!) {
      return const Home();
    }

    return const Login();
  }
}