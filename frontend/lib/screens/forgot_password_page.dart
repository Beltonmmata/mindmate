import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool loading = false;

  void sendOtp() async {
    setState(() => loading = true);
    final res = await AuthService.forgotPassword(emailController.text);
    setState(() => loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Error')));

    if (res['message'] != null && res['message'].contains('OTP sent')) {
      Navigator.pushNamed(
        context,
        '/reset-password',
        arguments: emailController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            CustomInput(
              controller: emailController,
              hintText: "Enter your email",
            ),
            SizedBox(height: 24),
            loading
                ? CircularProgressIndicator()
                : CustomButton(text: "Send OTP", onPressed: sendOtp),
          ],
        ),
      ),
    );
  }
}
