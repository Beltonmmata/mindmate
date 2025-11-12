import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final otpController = TextEditingController();
  bool loading = false;

  void verifyEmail(String email) async {
    setState(() => loading = true);
    final res = await AuthService.verifyEmail(email, otpController.text.trim());
    setState(() => loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Error')));

    if (res['message'] != null && res['message'].contains('verified')) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: Text("Verify Email")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text("OTP sent to: $email"),
            SizedBox(height: 12),
            CustomInput(controller: otpController, hintText: "Enter OTP"),
            SizedBox(height: 24),
            loading
                ? CircularProgressIndicator()
                : CustomButton(
                    text: "Verify",
                    onPressed: () => verifyEmail(email),
                  ),
          ],
        ),
      ),
    );
  }
}
