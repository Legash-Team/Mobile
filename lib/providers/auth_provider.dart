import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/donor_model.dart';
import '../services/api_service.dart';
import '../services/fcm_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  DonorInfo? _donor;
  bool _initialized = false;

  String? get token => _token;
  DonorInfo? get donor => _donor;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  bool get initialized => _initialized;

  AuthProvider() {
    restoreSession();
  }

  Future<void> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('session_token');
      final donorJson = prefs.getString('session_donor');

      if (token != null && token.isNotEmpty && donorJson != null) {
        _token = token;
        _donor = DonorInfo.fromJson(jsonDecode(donorJson) as Map<String, dynamic>);
        ApiService.token = token;
      }
    } catch (e) {
      if (kDebugMode) {
        print('[Auth] Error restoring session, clearing corrupted data: $e');
      }
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('session_token');
        await prefs.remove('session_donor');
      } catch (_) {}
      _token = null;
      _donor = null;
      ApiService.token = null;
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String token, DonorInfo donor) async {
    _token = token;
    _donor = donor;
    ApiService.token = token;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', token);
    await prefs.setString('session_donor', jsonEncode(donor.toJson()));

    FcmService.registerDeviceToken();
  }

  Future<void> logout() async {
    _token = null;
    _donor = null;
    ApiService.token = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
    await prefs.remove('session_donor');
  }

  Future<void> updateDonor(DonorInfo donor) async {
    _donor = donor;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_donor', jsonEncode(donor.toJson()));
  }
}
