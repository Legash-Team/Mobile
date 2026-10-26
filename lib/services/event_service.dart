import '../models/event_model.dart';
import 'api_service.dart';

class EventService {
  static Future<List<EventModel>> getEvents({String status = 'all'}) async {
    final query = status.isNotEmpty ? '?status=$status' : '';
    final res = await ApiService.get('/api/donor/events$query');
    final data = res['events'] ?? res['data'] ?? (res is List ? res : []);
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((item) => EventModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}