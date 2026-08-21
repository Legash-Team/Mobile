class EventModel {
  final String id;
  final String description;
  final String? mediaUrl;
  final String? mediaType;
  final String? applyLink;
  final DateTime closesAt;
  final String status;

  EventModel({
    required this.id,
    required this.description,
    this.mediaUrl,
    this.mediaType,
    this.applyLink,
    required this.closesAt,
    required this.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      description: json['description'] as String,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
      applyLink: json['applyLink'] as String?,
      closesAt: DateTime.parse(json['closesAt'] as String),
      status: json['status'] as String,
    );
  }
}