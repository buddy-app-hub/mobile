import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/services/auth_service.dart';

class PaymentApiService {
  static const String baseUrl = "https://payments.buddyapp.link"; // http://127.0.0.1:8000

  static Future<dynamic> get<T>({
    required String endpoint,
    Map<String, dynamic>? params,
  }) async {
    try {
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
        print('Error GET: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Error al obtener datos de payments: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception GET: $e');
      throw Exception('Excepción durante la solicitud GET: $e');
    }
  }

  static Future<dynamic> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
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
        print('Error POST: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Error al enviar datos a payments: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception POST: $e');
      throw Exception('Excepción durante la solicitud POST: $e');
    }
  }

  static Future<dynamic> patch<T>({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
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
        print('Error PATCH: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Error al actualizar datos en payments: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception PATCH: $e');
      throw Exception('Excepción durante la solicitud PATCH: $e');
    }
  }

  static Future<void> delete<T>({
    required String endpoint,
  }) async {
    try {
      final userToken = await AuthService().currentUser?.getIdToken();
      final headers = {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      };

      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Eliminación exitosa');
      } else {
        print('Error DELETE: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Error al eliminar datos en payments: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception DELETE: $e');
      throw Exception('Excepción durante la solicitud DELETE: $e');
    }
  }
}
