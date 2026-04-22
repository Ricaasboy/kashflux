import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/secure_storage_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          Center(
                            child: Image.asset(
                              'assets/imgs/complete_logo.png',
                              height: 90,
                            ),
                          ),

                          const SizedBox(height: 40),

                          Text(
                            'Login',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Enter your email and password to continue.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 32),

                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }

                              final emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+\-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(value);

                              if (!emailValid) {
                                return 'Please enter a valid email';
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 24),

                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }

                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }

                              return null;
                            },
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: const UnderlineInputBorder(),
                              enabledBorder: const UnderlineInputBorder(),
                              focusedBorder: const UnderlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        if (value == null) return;
                                        setState(() {
                                          _rememberMe = value;
                                        });
                                      },
                                    ),
                                    const Text('Remember me'),
                                  ],
                                ),
                              ),

                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  overlayColor: Colors.transparent,
                                ),
                                child: const Text('Forgot password?'),
                              ),
                            ],
                            ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final result = await AuthService.login(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(result['message'] ?? 'No response from server'),
                                    ),
                                  );

                                  if (result['success'] == true) {
                                    if (_rememberMe) {
                                      await SecureStorageService.saveLoginData(
                                        token: result['token'],
                                        username: result['user']['username'],
                                        email: result['user']['email'],
                                      );

                                      if (!mounted) return;
                                      Navigator.pushReplacementNamed(context, '/');
                                    } else {
                                      await SecureStorageService.clearLoginData();

                                      if (!mounted) return;
                                      Navigator.pushReplacementNamed(context, '/home');
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00C853),
                                foregroundColor: Colors.white,
                                elevation: 0, // remove sombra
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                overlayColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}