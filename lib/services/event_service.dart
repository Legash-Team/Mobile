import '../models/event_model.dart';
import 'api_service.dart';

class EventService {
  static Future<List<EventModel>> getEvents() async {
    final res = await ApiService.get('/api/donor/events');
    final data = res['events'];
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(EventModel.fromJson)
        .toList();
  }
}