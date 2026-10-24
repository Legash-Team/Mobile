import '../models/donation_record.dart';
import 'api_service.dart';

class DonationService {
  static Future<List<DonationRecord>> getDonationHistory() async {
    final res = await ApiService.get('/api/donor/donation-history');
    final data = res['donations'] ?? res['donationHistory'] ?? res;
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(DonationRecord.fromJson)
        .toList();
  }
}
