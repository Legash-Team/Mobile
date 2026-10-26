import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/constants.dart';
import 'package:egash_mobile/services/api_service.dart';

void main() {
  setUp(() {
    dotenv.clean();
  });

  group('API_BASE_URL dotenv configuration tests', () {
    test('Throws StateError if dotenv is uninitialized or API_BASE_URL is missing', () {
      expect(() => baseUrl, throwsStateError);
    });

    test('Throws StateError if API_BASE_URL is empty or whitespace', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=   ');
      expect(() => baseUrl, throwsStateError);
    });

    test('Throws FormatException if API_BASE_URL is not a valid HTTP/HTTPS URL', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=not-a-valid-url');
      expect(() => baseUrl, throwsFormatException);

      dotenv.testLoad(fileInput: 'API_BASE_URL=ftp://example.com');
      expect(() => baseUrl, throwsFormatException);
    });

    test('Trims trailing slashes correctly and returns clean base URL', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=http://10.109.95.152:3000///');
      expect(baseUrl, 'http://10.109.95.152:3000');
      expect(apiBaseUrl, 'http://10.109.95.152:3000');
    });

    test('Works cleanly with standard URL without trailing slashes', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=https://api.legash.org');
      expect(baseUrl, 'https://api.legash.org');
    });
  });

  group('ApiService.buildUri path resolution tests', () {
    setUp(() {
      dotenv.testLoad(fileInput: 'API_BASE_URL=http://192.168.1.9:3000');
    });

    test('Combines base URL with standard /api path', () {
      final uri = ApiService.buildUri('/api/donor/donation-history');
      expect(uri.toString(), 'http://192.168.1.9:3000/api/donor/donation-history');
    });

    test('Combines base URL with relative path without leading slash', () {
      final uri = ApiService.buildUri('api/donor/events');
      expect(uri.toString(), 'http://192.168.1.9:3000/api/donor/events');
    });

    test('Preserves query parameters properly', () {
      final uri = ApiService.buildUri('/api/donor/feed?page=1&limit=10');
      expect(uri.toString(), 'http://192.168.1.9:3000/api/donor/feed?page=1&limit=10');
      expect(uri.queryParameters['page'], '1');
      expect(uri.queryParameters['limit'], '10');
    });

    test('Handles full HTTP URL correctly without duplicating base URL', () {
      final uri = ApiService.buildUri('http://192.168.1.9:3000/api/donor/profile');
      expect(uri.toString(), 'http://192.168.1.9:3000/api/donor/profile');
    });

    test('Prevents duplicate /api when baseUrl already ends with /api and path starts with /api', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=http://192.168.1.9:3000/api');
      final uri = ApiService.buildUri('/api/donor/notifications');
      expect(uri.toString(), 'http://192.168.1.9:3000/api/donor/notifications');
    });
  });
}
