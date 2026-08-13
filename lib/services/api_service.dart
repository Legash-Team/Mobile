import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class ApiService {
  static String? token;

  static Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }

    final error = json['error'] as String?;
    throw ApiException(
      error ?? 'Something went wrong. Please try again.',
      response.statusCode,
    );
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await http.get(url, headers: _headers);

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }

    final error = json['error'] as String?;
    throw ApiException(
      error ?? 'Something went wrong. Please try again.',
      response.statusCode,
    );
  }
}