import '../models/event_model.dart';
import 'api_service.dart';

class EventService {
  static Future<List<EventModel>> getEvents() async {
    final res = await ApiService.get('/v2/events');
    final data = res['data'];
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(EventModel.fromJson)
        .toList();
  }
}