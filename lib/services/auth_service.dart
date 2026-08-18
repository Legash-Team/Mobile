import 'api_service.dart';
import '../models/donor_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> registerDonor(DonorModel data) async {
    return ApiService.post('/v1/donor/register', data.toJson());
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String code) async {
    return ApiService.post('/v1/donor/verify-otp', {
      'phone': phone,
      'code': code,
    });
  }

  static Future<Map<String, dynamic>> loginDonor(String phone, String password) async {
    return ApiService.post('/v1/donor/login', {
      'phone': phone,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> forgotPassword(String phone) async {
    return ApiService.post('/v1/donor/forgot-password', {
      'phone': phone,
    });
  }

  static Future<Map<String, dynamic>> resetPassword(
    String phone,
    String code,
    String newPassword,
  ) async {
    return ApiService.post('/v1/donor/reset-password', {
      'phone': phone,
      'code': code,
      'newPassword': newPassword,
    });
  }
}