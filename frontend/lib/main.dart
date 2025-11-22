import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/verify_email_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/reset_password_page.dart';
import 'screens/dashboard_wrapper.dart';
// ignore: unused_import
import 'screens/therapy_sessions_screen.dart';
// ignore: unused_import
import 'screens/mood_tracker_screen.dart';
// ignore: unused_import
import 'screens/journals_screen.dart';
// ignore: unused_import
import 'screens/community_screen.dart';
// ignore: unused_import
import 'screens/settings_screen.dart';
// ignore: unused_import
import 'screens/chat_screen.dart';
// ignore: unused_import
import 'screens/messages_screen.dart';
// ignore: unused_import
import 'screens/ai_therapy_screen.dart';
// ignore: unused_import
import 'screens/ai_tools_screen.dart';
// ignore: unused_import
import 'screens/therapists_screen.dart';
// ignore: unused_import
import 'screens/tips_screen.dart';
import 'providers/dashboard_provider.dart';

void main() {
  runApp(const MindMateApp());
}

class MindMateApp extends StatelessWidget {
  const MindMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MindMate',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (_) => const LandingPage(),
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/verify-email': (_) => const VerifyEmailPage(),
          '/forgot-password': (_) => const ForgotPasswordPage(),
          '/reset-password': (_) => const ResetPasswordPage(),
          '/dashboard': (_) => const DashboardWrapper(),
          '/therapy-sessions': (_) => const TherapySessionsScreen(),
          '/mood-tracker': (_) => const MoodTrackerScreen(),
          '/journals': (_) => const JournalsScreen(),
          '/community': (_) => const CommunityScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/chat': (_) => const ChatScreen(),
          '/messages': (_) => const MessagesScreen(),
          '/ai-therapy': (_) => const AITherapyScreen(),
          '/ai-tools': (_) => const AIToolsScreen(),
          '/therapists': (_) => const TherapistsScreen(),
          '/tips': (_) => const TipsScreen(),
        },
      ),
    );
  }
}
