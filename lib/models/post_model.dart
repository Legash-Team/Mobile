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
    return PostModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      content: json['content'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
      authorName: json['authorName'] as String? ?? 'Legash Admin',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  bool get hasMedia => mediaUrl != null && mediaUrl!.trim().isNotEmpty;
  bool get isVideo => mediaType == 'video';
  bool get isImage => mediaType == 'image' || (hasMedia && !isVideo);
}
