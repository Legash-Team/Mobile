import 'api_service.dart';
import '../models/donor_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> registerDonor(DonorModel data) async {
    return ApiService.post('/donor/register', data.toJson());
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String code) async {
    return ApiService.post('/donor/verify-otp', {
      'phone': phone,
      'code': code,
    });
  }

  static Future<Map<String, dynamic>> loginDonor(String phone, String password) async {
    return ApiService.post('/donor/login', {
      'phone': phone,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> forgotPassword(String phone) async {
    return ApiService.post('/donor/forgot-password', {
      'phone': phone,
    });
  }

  static Future<Map<String, dynamic>> resetPassword(
    String phone,
    String code,
    String newPassword,
  ) async {
    return ApiService.post('/donor/reset-password', {
      'phone': phone,
      'code': code,
      'newPassword': newPassword,
    });
  }
}