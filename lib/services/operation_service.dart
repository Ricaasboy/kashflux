import 'dart:convert';
import 'package:http/http.dart' as http;

class OperationService {
  static const String baseUrl = 'http://10.0.2.2/kashflux_api';

  static Future<Map<String, dynamic>> addOperation({
    required String email,
    required String type,
    required String category,
    required String title,
    required double amount,
    required String operationDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_operation.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'type': type,
          'category': category,
          'title': title,
          'amount': amount,
          'operation_date': operationDate,
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