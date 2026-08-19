import 'api_service.dart';
import '../models/donor_model.dart';
import '../utils/phone_formatter.dart';

class AuthService {
  static Future<Map<String, dynamic>> registerDonor(DonorModel data) async {
    final formatted = PhoneFormatter.format(data.phone);
    return ApiService.post('/v1/donor/register', data.toJson()..['phone'] = formatted);
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String code) async {
    return ApiService.post('/v1/donor/verify-otp', {
      'phone': PhoneFormatter.format(phone),
      'code': code,
    });
  }

  static Future<Map<String, dynamic>> loginDonor(String phone, String password) async {
    return ApiService.post('/v1/donor/login', {
      'phone': PhoneFormatter.format(phone),
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> forgotPassword(String phone) async {
    return ApiService.post('/v1/donor/forgot-password', {
      'phone': PhoneFormatter.format(phone),
    });
  }

  static Future<Map<String, dynamic>> resetPassword(
    String phone,
    String code,
    String newPassword,
  ) async {
    return ApiService.post('/v1/donor/reset-password', {
      'phone': PhoneFormatter.format(phone),
      'code': code,
      'newPassword': newPassword,
    });
  }
}
