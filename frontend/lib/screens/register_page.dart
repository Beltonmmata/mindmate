import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your name';
    return null;
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
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final res = await AuthService.register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
    );
    setState(() => loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Error')));

    if (res['message'] != null && res['message'].contains('OTP sent')) {
      Navigator.pushNamed(
        context,
        '/verify-email',
        arguments: emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Create account',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign up to get started',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 18),

              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomInput(
                          controller: nameController,
                          hintText: 'Full name',
                          label: 'Name',
                          validator: _validateName,
                        ),
                        const SizedBox(height: 12),
                        CustomInput(
                          controller: emailController,
                          hintText: 'Email',
                          label: 'Email',
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 12),
                        CustomInput(
                          controller: passwordController,
                          hintText: 'Password',
                          label: 'Password',
                          isPassword: true,
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 18),

                        CustomButton(
                          text: 'Register',
                          onPressed: register,
                          backgroundColor: Colors.deepOrange,
                          isLoading: loading,
                          loadingText: 'Creating account...',
                        ),

                        const SizedBox(height: 18),

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

                        // Additional sign-up options could go here
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom: prompt to sign in
              Column(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey[700]),
                        children: const [
                          TextSpan(
                            text: 'Sign in',
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
