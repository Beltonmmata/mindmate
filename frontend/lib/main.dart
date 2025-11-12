import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/verify_email_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/reset_password_page.dart';
import 'screens/dashboard_page.dart';

void main() {
  runApp(MindMateApp());
}

class MindMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindMate',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (_) => LandingPage(),
        '/login': (_) => LoginPage(),
        '/register': (_) => RegisterPage(),
        '/verify-email': (_) => VerifyEmailPage(),
        '/forgot-password': (_) => ForgotPasswordPage(),
        '/reset-password': (_) => ResetPasswordPage(),
        '/dashboard': (_) => DashboardPage(),
      },
    );
  }
}
