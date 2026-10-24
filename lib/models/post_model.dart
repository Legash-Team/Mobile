class PostModel {
  final String id;
  final String content;
  final String? mediaUrl;
  final String? mediaType;
  final String authorName;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.content,
    this.mediaUrl,
    this.mediaType,
    required this.authorName,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    String author = 'Legash Admin';
    if (json['authorName'] is String && (json['authorName'] as String).trim().isNotEmpty) {
      author = json['authorName'] as String;
    } else if (json['postedBy'] is String && (json['postedBy'] as String).trim().isNotEmpty) {
      author = json['postedBy'] as String;
    } else if (json['postedBy'] is Map) {
      final pb = json['postedBy'] as Map;
      final name = pb['name']?.toString() ?? pb['username']?.toString();
      if (name != null && name.trim().isNotEmpty) {
        author = name;
      }
    }

    final content = (json['content'] ?? json['body'] ?? json['text'] ?? '').toString();
    final media = (json['mediaUrl'] ?? json['imageUrl'] ?? json['videoUrl'])?.toString();

    return PostModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      content: content,
      mediaUrl: media,
      mediaType: json['mediaType'] as String? ?? (media != null && media.endsWith('.mp4') ? 'video' : 'image'),
      authorName: author,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  bool get hasMedia => mediaUrl != null && mediaUrl!.trim().isNotEmpty;
  bool get isVideo => mediaType == 'video';
  bool get isImage => mediaType == 'image' || (hasMedia && !isVideo);
}
