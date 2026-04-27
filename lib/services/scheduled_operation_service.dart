import 'dart:convert';
import 'package:http/http.dart' as http;

class ScheduledOperationService {
  static const String baseUrl = 'http://10.0.2.2/kashflux_api';

  static Future<Map<String, dynamic>> addScheduledOperation({
    required String email,
    required String type,
    required String category,
    required String title,
    required double amount,
    required String repeatType,
    required int scheduledDay,
    int? scheduledMonth,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_scheduled_operation.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'type': type,
          'category': category,
          'title': title,
          'amount': amount,
          'repeat_type': repeatType,
          'scheduled_day': scheduledDay,
          'scheduled_month': scheduledMonth,
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

  static Future<Map<String, dynamic>> processScheduledOperations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/process_scheduled_operations.php'),
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