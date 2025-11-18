import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final res = await AuthService.login(
      emailController.text.trim(),
      passwordController.text,
    );
    setState(() => loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Error')));

    if (res['token'] != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter email';
    final email = value.trim();
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    if (!emailRegex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter password';
    //if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top texts
              const SizedBox(height: 8),
              Text(
                'Welcome back',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Signing into your account',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email — use CustomInput (floating label + focus border)
                        CustomInput(
                          controller: emailController,
                          hintText: 'Enter your email',
                          label: 'Email',
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 12),

                        // Password — using CustomInput with password toggle
                        CustomInput(
                          controller: passwordController,
                          hintText: 'Enter your password',
                          label: 'Password',
                          isPassword: true,
                          validator: _validatePassword,
                        ),

                        // Forgot password (right aligned)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/forgot-password',
                            ),
                            child: const Text('Forgot Password?'),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Login button — use the same style as landing page, deepOrange primary
                        CustomButton(
                          text: 'Login',
                          onPressed: login,
                          backgroundColor: Colors.deepOrange,
                          isLoading: loading,
                          loadingText: 'Authenticating...',
                        ),

                        const SizedBox(height: 18),

                        // OR separator
                        Row(
                          children: <Widget>[
                            Expanded(child: Divider(color: Colors.grey[300])),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'OR',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Optional extra content or social login could go here
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom: Register prompt
              Column(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.grey[700]),
                        children: const [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
