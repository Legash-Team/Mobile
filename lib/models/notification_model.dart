class NotificationModel {
  final String id;
  final String hospitalName;
  final String? hospitalPhone;
  final String? hospitalAddress;
  final double? hospitalLat;
  final double? hospitalLng;
  final String bloodType;
  final int quantityNeeded;
  final bool isEmergency;
  final String? description;
  final String myResponseStatus;
  final String requestStatus;
  final DateTime notifiedAt;
  final DateTime? closesAt;
  final String? title;
  final String? message;
  final String? category;
  final String? type;
  final String? requestId;

  NotificationModel({
    required this.id,
    required this.hospitalName,
    this.hospitalPhone,
    this.hospitalAddress,
    this.hospitalLat,
    this.hospitalLng,
    required this.bloodType,
    required this.quantityNeeded,
    this.isEmergency = false,
    this.description,
    required this.myResponseStatus,
    required this.requestStatus,
    required this.notifiedAt,
    this.closesAt,
    this.title,
    this.message,
    this.category,
    this.type,
    this.requestId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String? address;
    double? lat;
    double? lng;

    if (json['hospitalLocation'] != null && json['hospitalLocation'] is Map) {
      final loc = json['hospitalLocation'] as Map<String, dynamic>;
      address = loc['address'] as String?;
      if (loc['coordinates'] is List && (loc['coordinates'] as List).length >= 2) {
        final coords = loc['coordinates'] as List;
        lng = (coords[0] as num?)?.toDouble();
        lat = (coords[1] as num?)?.toDouble();
      }
    }

    final rawMyStatus = (json['myResponseStatus'] as String? ??
            json['status'] as String? ??
            'pending')
        .toLowerCase()
        .trim();

    final rawReqStatus = (json['requestStatus'] as String? ??
            json['bloodRequestStatus'] as String? ??
            'open')
        .toLowerCase()
        .trim();

    final isEmerg = json['isEmergency'] as bool? ?? false;
    final hospName = json['hospitalName'] as String? ?? 'Blood Center / Hospital';
    final bType = json['bloodType'] as String? ?? 'Any';

    final title = json['title'] as String? ??
        (isEmerg ? 'Urgent Blood Alert' : 'Blood Donation Request');
    final message = json['message'] as String? ??
        json['body'] as String? ??
        '$hospName requested $bType blood. Tap to respond.';
    final category = json['category'] as String? ?? (isEmerg ? 'Emergency' : 'Request');
    final type = json['type'] as String? ?? 'BLOOD_REQUEST';
    final reqId = (json['requestId'] ?? json['bloodRequestId'])?.toString();

    return NotificationModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      hospitalName: hospName,
      hospitalPhone: json['hospitalPhone'] as String?,
      hospitalAddress: address,
      hospitalLat: lat,
      hospitalLng: lng,
      bloodType: bType,
      quantityNeeded: (json['quantityNeeded'] as num?)?.toInt() ?? 1,
      isEmergency: isEmerg,
      description: json['description'] as String?,
      myResponseStatus: rawMyStatus,
      requestStatus: rawReqStatus,
      notifiedAt: json['notifiedAt'] != null
          ? DateTime.tryParse(json['notifiedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      closesAt: json['closesAt'] != null
          ? DateTime.tryParse(json['closesAt'] as String)
          : null,
      title: title,
      message: message,
      category: category,
      type: type,
      requestId: reqId,
    );
  }

  NotificationModel copyWith({
    String? myResponseStatus,
    String? requestStatus,
    String? hospitalPhone,
    String? hospitalAddress,
    double? hospitalLat,
    double? hospitalLng,
    String? title,
    String? message,
    String? category,
    String? type,
    String? requestId,
  }) {
    return NotificationModel(
      id: id,
      hospitalName: hospitalName,
      hospitalPhone: hospitalPhone ?? this.hospitalPhone,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      hospitalLat: hospitalLat ?? this.hospitalLat,
      hospitalLng: hospitalLng ?? this.hospitalLng,
      bloodType: bloodType,
      quantityNeeded: quantityNeeded,
      isEmergency: isEmergency,
      description: description,
      myResponseStatus: myResponseStatus ?? this.myResponseStatus,
      requestStatus: requestStatus ?? this.requestStatus,
      notifiedAt: notifiedAt,
      closesAt: closesAt,
      title: title ?? this.title,
      message: message ?? this.message,
      category: category ?? this.category,
      type: type ?? this.type,
      requestId: requestId ?? this.requestId,
    );
  }

  String get displayTitle => title ?? (isEmergency ? 'Urgent Blood Alert' : 'Blood Donation Request');
  String get displayMessage => message ?? '$hospitalName requested $bloodType blood. Tap to respond.';
  String get displayCategory => category ?? (isEmergency ? 'Emergency' : 'Request');

  bool get isPending =>
      myResponseStatus == 'pending' ||
      myResponseStatus == 'ongoing' ||
      myResponseStatus == 'waiting';

  bool get isAccepted => myResponseStatus == 'accepted';

  bool get isDenied =>
      myResponseStatus == 'denied' ||
      myResponseStatus == 'declined' ||
      myResponseStatus == 'rejected';

  bool get isOpen => requestStatus == 'open';

  bool get isClosed => requestStatus == 'closed' || requestStatus == 'expired';
}