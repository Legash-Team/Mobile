import '../models/donation_record.dart';
import 'api_service.dart';

class DonationService {
  static Future<List<DonationRecord>> getDonationHistory() async {
    final res = await ApiService.get('/api/donor/donation-history');
    final data = res['donations'] ?? res['records'] ?? res['donationHistory'] ?? (res is List ? res : []);
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((item) => DonationRecord.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
