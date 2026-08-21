import 'package:flutter/foundation.dart';
import '../models/donor_model.dart';
import '../services/api_service.dart';
import '../services/fcm_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  DonorInfo? _donor;

  String? get token => _token;
  DonorInfo? get donor => _donor;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  void login(String token, DonorInfo donor) {
    _token = token;
    _donor = donor;
    ApiService.token = token;
    notifyListeners();
    FcmService.registerDeviceToken();
  }

  void logout() {
    _token = null;
    _donor = null;
    ApiService.token = null;
    notifyListeners();
  }
}