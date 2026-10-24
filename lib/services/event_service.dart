import '../models/event_model.dart';
import 'api_service.dart';

class EventService {
  static Future<List<EventModel>> getEvents() async {
    final res = await ApiService.get('/api/donor/events');
    final data = res['events'] ?? res['data'] ?? (res is List ? res : []);
    if (data is! List) return [];
    return data
        .where((item) => item is Map)
        .map((item) => EventModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}