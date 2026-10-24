class EventModel {
  final String id;
  final String title;
  final String description;
  final String? mediaUrl;
  final String? mediaType;
  final String? applyLink;
  final DateTime closesAt;
  final String status;
  final DateTime? createdAt;
  final String? postedBy;

  EventModel({
    required this.id,
    this.title = 'Blood Donation Event',
    required this.description,
    this.mediaUrl,
    this.mediaType,
    this.applyLink,
    required this.closesAt,
    required this.status,
    this.createdAt,
    this.postedBy,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedClosesAt;
    if (json['closesAt'] != null) {
      parsedClosesAt = DateTime.tryParse(json['closesAt'].toString()) ??
          DateTime.now().add(const Duration(days: 7));
    } else if (json['eventDate'] != null) {
      parsedClosesAt = DateTime.tryParse(json['eventDate'].toString()) ??
          DateTime.now().add(const Duration(days: 7));
    } else if (json['date'] != null) {
      parsedClosesAt = DateTime.tryParse(json['date'].toString()) ??
          DateTime.now().add(const Duration(days: 7));
    } else {
      parsedClosesAt = DateTime.now().add(const Duration(days: 7));
    }

    final rawStatus = (json['status'] as String? ?? 'open').toLowerCase().trim();
    final isExpired = parsedClosesAt.isBefore(DateTime.now());

    String? parsedPostedBy;
    if (json['postedBy'] is String) {
      parsedPostedBy = json['postedBy'] as String;
    } else if (json['postedBy'] is Map) {
      final pb = json['postedBy'] as Map;
      parsedPostedBy = pb['name']?.toString() ?? pb['username']?.toString();
    }

    final media = (json['mediaUrl'] ?? json['imageUrl'] ?? json['videoUrl'])?.toString();

    return EventModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: json['title'] as String? ?? 'Blood Donation Drive',
      description: json['description'] as String? ?? '',
      mediaUrl: media,
      mediaType: json['mediaType'] as String? ?? (media != null && media.endsWith('.mp4') ? 'video' : 'image'),
      applyLink: json['applyLink'] as String?,
      closesAt: parsedClosesAt,
      status: isExpired ? 'closed' : rawStatus,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      postedBy: parsedPostedBy,
    );
  }

  bool get isOpen => status == 'open' && closesAt.isAfter(DateTime.now());
  bool get hasMedia => mediaUrl != null && mediaUrl!.trim().isNotEmpty;
  bool get isVideo => mediaType == 'video';
  bool get hasApplyLink => applyLink != null && applyLink!.trim().isNotEmpty;
}