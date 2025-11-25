import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class AuthService {
  // REGISTER
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$BASE_URL/auth/register');
    final body = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
    });
    try {
      print('AuthService.register -> POST $url');
      // print('Request body: $body');
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      //print('Response ${res.statusCode}: ${res.body}');
      return jsonDecode(res.body);
    } catch (e) {
      print('AuthService.register error: $e');
      return {"message": "Network error: $e"};
    }
  }

  // VERIFY EMAIL
  static Future<Map<String, dynamic>> verifyEmail(
    String email,
    String otp,
  ) async {
    final url = Uri.parse('$BASE_URL/auth/verify-email');
    final body = jsonEncode({"email": email, "otp": otp});
    try {
      print('AuthService.verifyEmail -> POST $url');
      print('Request body: $body');
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      print('Response ${res.statusCode}: ${res.body}');
      return jsonDecode(res.body);
    } catch (e) {
      print('AuthService.verifyEmail error: $e');
      return {"message": "Network error: $e"};
    }
  }

  // RESEND OTP
  static Future<Map<String, dynamic>> resendOtp(String email) async {
    final url = Uri.parse('$BASE_URL/auth/resend-otp');
    final body = jsonEncode({"email": email});
    try {
      print('AuthService.resendOtp -> POST $url');
      print('Request body: $body');
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      print('Response ${res.statusCode}: ${res.body}');
      return jsonDecode(res.body);
    } catch (e) {
      print('AuthService.resendOtp error: $e');
      return {"message": "Network error: $e"};
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$BASE_URL/auth/login');
    final body = jsonEncode({"email": email, "password": password});
    try {
      print('AuthService.login -> POST $url');
      //print('Request body: $body');
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      //print('Response ${res.statusCode}: ${res.body}');
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(TOKEN_KEY, data['token']);
        // Save user object and full auth response for later use in dashboard
        if (data.containsKey('user')) {
          await prefs.setString('user', jsonEncode(data['user']));
        }
        await prefs.setString('auth_response', jsonEncode(data));
      }
      return data;
    } catch (e) {
      print('AuthService.login error: $e');
      return {"message": "Network error: $e"};
    }
  }

  // FORGOT PASSWORD
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$BASE_URL/auth/forgot-password');
    final body = jsonEncode({"email": email});
    try {
      print('AuthService.forgotPassword -> POST $url');
      // print('Request body: $body');
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      // print('Response ${res.statusCode}: ${res.body}');
      return jsonDecode(res.body);
    } catch (e) {
      print('AuthService.forgotPassword error: $e');
      return {"message": "Network error: $e"};
    }
  }

  // RESET PASSWORD
  static Future<Map<String, dynamic>> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    final url = Uri.parse('$BASE_URL/auth/reset-password');
    final body = jsonEncode({
      "email": email,
      "otp": otp,
      "newPassword": newPassword,
    });
    try {
      print('AuthService.resetPassword -> POST $url');
      //  print('Request body: $body');
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      // print('Response ${res.statusCode}: ${res.body}');
      return jsonDecode(res.body);
    } catch (e) {
      print('AuthService.resetPassword error: $e');
      return {"message": "Network error: $e"};
    }
  }

  // GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY);
  }

  // Get saved user object (if any)
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('user');
    if (s == null) return null;
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // Get the raw saved auth response
  static Future<Map<String, dynamic>?> getAuthResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('auth_response');
    if (s == null) return null;
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
    await prefs.remove('user');
    await prefs.remove('auth_response');
  }

  // Clear all saved auth info (token + user + auth response)
  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
    await prefs.remove('user');
    await prefs.remove('auth_response');
  }

  // Debug helper: print stored token, user and auth response
  static Future<void> logSavedAuth() async {
    final token = await getToken();
    final user = await getUser();
    final auth = await getAuthResponse();
    print('---- Saved Auth ----');
    print('token: $token');
    print('user: $user');
    print('auth_response: $auth');
    print('--------------------');
  }
}
