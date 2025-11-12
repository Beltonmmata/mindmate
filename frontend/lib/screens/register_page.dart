import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  void register() async {
    setState(() => loading = true);
    final res = await AuthService.register(
      nameController.text,
      emailController.text,
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
        arguments: emailController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            CustomInput(controller: nameController, hintText: "Name"),
            SizedBox(height: 12),
            CustomInput(controller: emailController, hintText: "Email"),
            SizedBox(height: 12),
            CustomInput(
              controller: passwordController,
              hintText: "Password",
              isPassword: true,
            ),
            SizedBox(height: 24),
            loading
                ? CircularProgressIndicator()
                : CustomButton(text: "Register", onPressed: register),
          ],
        ),
      ),
    );
  }
}
