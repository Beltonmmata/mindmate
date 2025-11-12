import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  void resetPassword(String email) async {
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

    if (res['message'] != null && res['message'].contains('successful')) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text("OTP sent to: $email"),
            SizedBox(height: 12),
            CustomInput(controller: otpController, hintText: "Enter OTP"),
            SizedBox(height: 12),
            CustomInput(
              controller: passwordController,
              hintText: "New Password",
              isPassword: true,
            ),
            SizedBox(height: 24),
            loading
                ? CircularProgressIndicator()
                : CustomButton(
                    text: "Reset Password",
                    onPressed: () => resetPassword(email),
                  ),
          ],
        ),
      ),
    );
  }
}
