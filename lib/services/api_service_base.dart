import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/services/auth_service.dart';

class ApiService {
  static const String baseUrl = ""; // http://localhost:8080

  // Map<String, T>
  static Future<dynamic> get<T>(
      {
        required String endpoint,
        Map<String, dynamic>? params
      }) async {

    final userToken = await AuthService().currentUser?.getIdToken();
    final headers = {
      'Authorization': 'Bearer ${userToken}',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(uri.replace(queryParameters: params), headers: headers);

    return jsonDecode(response.body);
  }
}