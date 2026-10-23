import '../models/post_model.dart';
import 'api_service.dart';

class PostService {
  static Future<List<PostModel>> getFeed({int page = 1, int limit = 10}) async {
    final res = await ApiService.get('/api/donor/feed?page=$page&limit=$limit');
    final data = res['posts'] ?? res['feed'] ?? (res is List ? res : []);
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList();
  }
}
