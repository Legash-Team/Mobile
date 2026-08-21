import '../models/notification_model.dart';
import 'api_service.dart';

class NotificationService {
  static Future<List<NotificationModel>> getNotifications({String? status}) async {
    final query = status == null ? '' : '?status=$status';
    final res = await ApiService.get('/api/donor/notifications$query');
    final data = res['notifications'];
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(NotificationModel.fromJson)
        .toList();
  }

  static Future<Map<String, dynamic>> accept(String id) async {
    return ApiService.post('/api/donor/notifications/$id/respond', {
      'response': 'accepted',
    });
  }

  static Future<Map<String, dynamic>> decline(String id) async {
    return ApiService.post('/api/donor/notifications/$id/respond', {
      'response': 'denied',
    });
  }
}