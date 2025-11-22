import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final otpController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyEmail(String email) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final res = await AuthService.verifyEmail(email, otpController.text.trim());
    setState(() => loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Error')));

    if (res['message'] != null &&
        res['message'].toString().toLowerCase().contains('verified')) {
      Navigator.pushNamed(context, '/login');
    }
  }

  Future<void> resendOtp(String email) async {
    setState(() => loading = true);
    final res = await AuthService.resendOtp(email);
    setState(() => loading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Error')));
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Verify your email',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text('An OTP was sent to', style: TextStyle(color: Colors.grey)),
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
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter the OTP';
                            }
                            if (v.trim().length < 4) {
                              return 'OTP seems too short';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        CustomButton(
                          text: 'Verify',
                          onPressed: () => verifyEmail(email),
                          backgroundColor: Colors.deepOrange,
                          isLoading: loading,
                          loadingText: 'Verifying...',
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Didn\'t receive it? '),
                            TextButton(
                              onPressed: () => resendOtp(email),
                              child: const Text('Resend OTP'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        const Divider(color: Colors.grey),
                        const SizedBox(height: 12),

                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/register',
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: 'Wrong email? ',
                                style: TextStyle(color: Colors.grey[700]),
                                children: const [
                                  TextSpan(
                                    text: 'Change email',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
