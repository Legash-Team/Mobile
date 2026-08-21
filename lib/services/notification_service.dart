import '../models/notification_model.dart';
import 'api_service.dart';

class NotificationService {
  /// Fetch list of all blood request notifications for the current donor
  static Future<List<NotificationModel>> getNotifications() async {
    final res = await ApiService.get('/v1/donor/notifications');
    final data = res['data'];
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(NotificationModel.fromJson)
        .toList();
  }

  /// Accept an emergency blood request
  static Future<Map<String, dynamic>> accept(String notificationId) async {
    return ApiService.post('/v1/donor/notifications/$notificationId/respond', {
      'status': 'accepted',
    });
  }

  /// Decline an emergency blood request
  static Future<Map<String, dynamic>> decline(String notificationId) async {
    return ApiService.post('/v1/donor/notifications/$notificationId/respond', {
      'status': 'denied',
    });
  }
}