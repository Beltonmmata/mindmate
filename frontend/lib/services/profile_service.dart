import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'auth_service.dart';

class ProfileService {
  // --- BUILD AUTH HEADERS ---
  Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await AuthService.getToken();

    return {
      HttpHeaders.authorizationHeader: "Bearer $token",
      if (json) "Content-Type": "application/json",
    };
  }

  // --- SAFE HTTP RESPONSE HANDLER ---
  Map<String, dynamic> _parseResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }
    throw Exception("Request failed: ${res.statusCode} → ${res.body}");
  }

  // --- GET PROFILE ---
  Future<Map<String, dynamic>> getProfile() async {
    final headers = await _headers();

    final res = await http.get(
      Uri.parse('$BASE_URL/users/profile'),
      headers: headers,
    );

    return _parseResponse(res);
  }

  // --- UPDATE PROFILE ---
  Future<Map<String, dynamic>> updateProfile(String name, String email) async {
    final headers = await _headers(json: true);

    final res = await http.patch(
      Uri.parse('$BASE_URL/users/profile'),
      headers: headers,
      body: jsonEncode({"name": name, "email": email}),
    );

    return _parseResponse(res);
  }

  // --- UPLOAD PROFILE PICTURE ---
  Future<Map<String, dynamic>> uploadProfilePicture(File file) async {
    final token = await AuthService.getToken();

    final request = http.MultipartRequest(
      "PATCH",
      Uri.parse('$BASE_URL/users/profile-picture'),
    );

    request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";

    request.files.add(await http.MultipartFile.fromPath("image", file.path));

    final res = await request.send();
    final body = await res.stream.bytesToString();

    return jsonDecode(body);
  }

  // --- DELETE ACCOUNT ---
  Future<Map<String, dynamic>> deleteAccount() async {
    final headers = await _headers();

    final res = await http.delete(
      Uri.parse('$BASE_URL/users/me'),
      headers: headers,
    );

    return _parseResponse(res);
  }
}
