import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final res = await AuthService.forgotPassword(emailController.text.trim());
    setState(() => loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Error')));

    if (res['message'] != null &&
        res['message'].toString().contains('OTP sent')) {
      Navigator.pushNamed(
        context,
        '/reset-password',
        arguments: emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Forgot password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your account email to receive an OTP',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 18),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomInput(
                      controller: emailController,
                      hintText: 'Email',
                      label: 'Email',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Please enter email';
                        final email = v.trim();
                        final emailRegex = RegExp(
                          r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}",
                        );
                        if (!emailRegex.hasMatch(email))
                          return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    CustomButton(
                      text: 'Send OTP',
                      onPressed: sendOtp,
                      backgroundColor: Colors.deepOrange,
                      isLoading: loading,
                      loadingText: 'Sending...',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
