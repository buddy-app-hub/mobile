import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/services/auth_service.dart';

class PaymentApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<dynamic> get<T>({
    required String endpoint,
    Map<String, dynamic>? params,
  }) async {
    final userToken = await AuthService().currentUser?.getIdToken();
    final headers = {
      'Authorization': 'Bearer $userToken',
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

  static Future<dynamic> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final userToken = await AuthService().currentUser?.getIdToken();
    final headers = {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al enviar datos al endpoint');
    }
  }

  static Future<dynamic> patch<T>({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final userToken = await AuthService().currentUser?.getIdToken();
    final headers = {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.patch(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar datos en el endpoint');
    }
  }

  static Future<void> delete<T>({
    required String endpoint,
  }) async {
    final userToken = await AuthService().currentUser?.getIdToken();
    final headers = {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(uri, headers: headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar datos en el endpoint');
    }
  }
}
