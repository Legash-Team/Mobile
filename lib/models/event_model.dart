class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String? location;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    this.location,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final venue = json['venueLocation'];
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      location: json['location'] as String? ??
          (venue is Map<String, dynamic> ? venue['address'] as String? : null),
    );
  }
}