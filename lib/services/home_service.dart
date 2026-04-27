import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeService {
  static const String baseUrl = 'http://10.0.2.2/kashflux_api';

  static Future<Map<String, dynamic>> getHomeData({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/home.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }
}