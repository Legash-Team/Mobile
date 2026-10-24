import '../models/post_model.dart';
import 'api_service.dart';

class PostService {
  static Future<List<PostModel>> getFeed({int page = 1, int limit = 10}) async {
    final res = await ApiService.get('/api/donor/feed?page=$page&limit=$limit');
    final data = res['posts'] ?? res['feed'] ?? res['data'] ?? (res is List ? res : []);
    if (data is! List) return [];
    return data
        .where((item) => item is Map)
        .map((item) => PostModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
