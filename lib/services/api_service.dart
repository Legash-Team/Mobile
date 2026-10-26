import 'dart:convert';
import 'package:flutter/foundation.dart';
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

  static Uri _buildUri(String path) {
    final cleanBase = baseUrl.replaceAll(RegExp(r'/+$'), '');
    var subPath = path.trim();
    if (subPath.startsWith('http://') || subPath.startsWith('https://')) {
      final parsed = Uri.parse(subPath);
      subPath = parsed.path + (parsed.hasQuery ? '?${parsed.query}' : '');
    }
    var cleanPath = subPath.startsWith('/') ? subPath : '/$subPath';

    // Prevent duplicate /api if cleanBase already ends with /api and cleanPath starts with /api/
    if (cleanBase.endsWith('/api') && cleanPath.startsWith('/api/')) {
      cleanPath = cleanPath.substring(4);
    }

    return Uri.parse('$cleanBase$cleanPath');
  }

  /// Exposed for testing path resolution
  static Uri buildUri(String path) => _buildUri(path);

  static String _extractErrorMessage(http.Response response) {
    try {
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final err = decoded['error'];
          if (err != null && err.toString().trim().isNotEmpty) {
            return err.toString().trim();
          }
          final msg = decoded['message'];
          if (msg != null && msg.toString().trim().isNotEmpty) {
            return msg.toString().trim();
          }
        }
      }
    } catch (_) {
      // Ignore JSON decode errors
    }
    return 'Something went wrong. Please try again.';
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    Uri? url;
    try {
      url = _buildUri(path);
      debugPrint('[ApiService] POST $url');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );
      debugPrint('[ApiService] POST $url -> Status ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return <String, dynamic>{'success': true};
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return <String, dynamic>{'success': true, 'data': decoded};
      }

      final errMsg = _extractErrorMessage(response);
      debugPrint('[ApiService] POST $url -> Error ${response.statusCode}: $errMsg');
      throw ApiException(errMsg, response.statusCode);
    } on ApiException {
      rethrow;
    } on StateError {
      rethrow;
    } on FormatException {
      rethrow;
    } catch (e) {
      debugPrint('[ApiService] POST ${url ?? path} -> Connection failed: $e');
      throw ApiException(
        'Cannot connect to server at $baseUrl ($e). Ensure the backend is running and reachable on your network.',
        0,
      );
    }
  }

  static Future<Map<String, dynamic>> get(String path) async {
    Uri? url;
    try {
      url = _buildUri(path);
      debugPrint('[ApiService] GET $url');
      final response = await http.get(url, headers: _headers);
      debugPrint('[ApiService] GET $url -> Status ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return <String, dynamic>{'success': true};
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return <String, dynamic>{'success': true, 'data': decoded};
      }

      final errMsg = _extractErrorMessage(response);
      debugPrint('[ApiService] GET $url -> Error ${response.statusCode}: $errMsg');
      throw ApiException(errMsg, response.statusCode);
    } on ApiException {
      rethrow;
    } on StateError {
      rethrow;
    } on FormatException {
      rethrow;
    } catch (e) {
      debugPrint('[ApiService] GET ${url ?? path} -> Connection failed: $e');
      throw ApiException(
        'Cannot connect to server at $baseUrl ($e). Ensure the backend is running and reachable on your network.',
        0,
      );
    }
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    Uri? url;
    try {
      url = _buildUri(path);
      debugPrint('[ApiService] PUT $url');
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );
      debugPrint('[ApiService] PUT $url -> Status ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return <String, dynamic>{'success': true};
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return <String, dynamic>{'success': true, 'data': decoded};
      }

      final errMsg = _extractErrorMessage(response);
      debugPrint('[ApiService] PUT $url -> Error ${response.statusCode}: $errMsg');
      throw ApiException(errMsg, response.statusCode);
    } on ApiException {
      rethrow;
    } on StateError {
      rethrow;
    } on FormatException {
      rethrow;
    } catch (e) {
      debugPrint('[ApiService] PUT ${url ?? path} -> Connection failed: $e');
      throw ApiException(
        'Cannot connect to server at $baseUrl ($e). Ensure the backend is running and reachable on your network.',
        0,
      );
    }
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    Uri? url;
    try {
      url = _buildUri(path);
      debugPrint('[ApiService] DELETE $url');
      final response = await http.delete(url, headers: _headers);
      debugPrint('[ApiService] DELETE $url -> Status ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return <String, dynamic>{'success': true};
        }
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return <String, dynamic>{'success': true, 'data': decoded};
      }

      final errMsg = _extractErrorMessage(response);
      debugPrint('[ApiService] DELETE $url -> Error ${response.statusCode}: $errMsg');
      throw ApiException(errMsg, response.statusCode);
    } on ApiException {
      rethrow;
    } on StateError {
      rethrow;
    } on FormatException {
      rethrow;
    } catch (e) {
      debugPrint('[ApiService] DELETE ${url ?? path} -> Connection failed: $e');
      throw ApiException(
        'Cannot connect to server at $baseUrl ($e). Ensure the backend is running and reachable on your network.',
        0,
      );
    }
  }
}