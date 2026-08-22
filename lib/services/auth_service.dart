import 'api_service.dart';
import '../models/donor_model.dart';
import '../utils/phone_formatter.dart';

class AuthService {
  static Future<Map<String, dynamic>> registerDonor(DonorModel data) async {
    final formatted = PhoneFormatter.format(data.phone);
    return ApiService.post('/api/donor/register', data.toJson()..['phone'] = formatted);
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String code) async {
    return ApiService.post('/api/donor/verify-otp', {
      'phone': PhoneFormatter.format(phone),
      'code': code,
    });
  }

  static Future<Map<String, dynamic>> resendOtp(String phone) async {
    return ApiService.post('/api/donor/resend-otp', {
      'phone': PhoneFormatter.format(phone),
    });
  }

  static Future<Map<String, dynamic>> setPin(String phone, String pin, String confirmPin) async {
    return ApiService.post('/api/donor/set-pin', {
      'phone': PhoneFormatter.format(phone),
      'pin': pin,
      'confirmPin': confirmPin,
    });
  }

  static Future<Map<String, dynamic>> unlock(String phone, String pin) async {
    return ApiService.post('/api/donor/unlock', {
      'phone': PhoneFormatter.format(phone),
      'pin': pin,
    });
  }

  static Future<Map<String, dynamic>> forgotPin(String phone) async {
    return ApiService.post('/api/donor/forgot-pin', {
      'phone': PhoneFormatter.format(phone),
    });
  }

  static Future<Map<String, dynamic>> resetPin(
    String phone,
    String code,
    String pin,
    String confirmPin,
  ) async {
    return ApiService.post('/api/donor/reset-pin', {
      'phone': PhoneFormatter.format(phone),
      'code': code,
      'pin': pin,
      'confirmPin': confirmPin,
    });
  }

  static Future<Map<String, dynamic>> changePin(
    String currentPin,
    String newPin,
    String confirmNewPin,
  ) async {
    return ApiService.post('/api/donor/profile/change-pin', {
      'currentPin': currentPin,
      'newPin': newPin,
      'confirmPin': confirmNewPin,
    });
  }

  static Future<Map<String, dynamic>> getProfile() async {
    return ApiService.get('/api/donor/profile');
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return ApiService.put('/api/donor/profile', data);
  }

  static Future<Map<String, dynamic>> deleteAccount() async {
    return ApiService.delete('/api/donor/profile');
  }
}
