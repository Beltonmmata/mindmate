// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$BASE_URL/$endpoint');
    final body = jsonEncode(data);
    try {
      print('ApiService.post -> POST $url');
      print('Request body: $body');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print('Response ${response.statusCode}: ${response.body}');
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse;
      } else {
        throw Exception(jsonResponse['message'] ?? 'API request failed');
      }
    } catch (e) {
      print('ApiService.post error: $e');
      rethrow;
    }
  }
}
