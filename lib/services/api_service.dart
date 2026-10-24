import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

// this is where we will handle all the api calls and error handling
class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() => message;
}

// the above class is user to handle api exceptions and error comes from backend and we 
//will use it in the api service class to throw exceptions when the api call fails



class ApiService {
  static String? token;// this is used to store the token after login and
  // we will use it in the headers of the api calls

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
    try {
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
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Cannot connect to server at $baseUrl. Ensure your local server is running (e.g. node tool/mock_server.js).',
        0,
      );
    }
  }

  static Future<Map<String, dynamic>> get(String path) async {
    try {
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
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Cannot connect to server at $baseUrl. Ensure your local server is running (e.g. node tool/mock_server.js).',
        0,
      );
    }
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$path');
      final response = await http.put(
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
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Cannot connect to server at $baseUrl. Ensure your local server is running (e.g. node tool/mock_server.js).',
        0,
      );
    }
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    try {
      final url = Uri.parse('$baseUrl$path');
      final response = await http.delete(url, headers: _headers);

      if (response.body.isEmpty) {
        return <String, dynamic>{'success': true};
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json;
      }

      final error = json['error'] as String?;
      throw ApiException(
        error ?? 'Something went wrong. Please try again.',
        response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Cannot connect to server at $baseUrl. Ensure your local server is running (e.g. node tool/mock_server.js).',
        0,
      );
    }
  }
}