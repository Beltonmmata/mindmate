import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword(String email) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final res = await AuthService.resetPassword(
      email,
      otpController.text.trim(),
      passwordController.text,
    );
    setState(() => loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Error')));

    if (res['message'] != null &&
        res['message'].toString().toLowerCase().contains('successful')) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Reset password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter the OTP sent to',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(email, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),

              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomInput(
                          controller: otpController,
                          hintText: 'Enter OTP',
                          label: 'OTP',
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Please enter the OTP';
                            if (v.trim().length < 4)
                              return 'OTP seems too short';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomInput(
                          controller: passwordController,
                          hintText: 'New password',
                          label: 'New Password',
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Please enter a new password';
                            if (v.length < 6)
                              return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        CustomButton(
                          text: 'Reset Password',
                          onPressed: () => resetPassword(email),
                          backgroundColor: Colors.deepOrange,
                          isLoading: loading,
                          loadingText: 'Resetting...',
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Didn\'t receive it? '),
                            TextButton(
                              onPressed: () =>
                                  AuthService.resendOtp(email).then(
                                    (res) => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              res['message'] ?? 'Error',
                                            ),
                                          ),
                                        ),
                                  ),
                              child: const Text('Resend OTP'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
