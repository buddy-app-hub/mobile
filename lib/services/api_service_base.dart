import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/services/auth_service.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8086";

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

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener datos del endpoint');
    }
  }
}