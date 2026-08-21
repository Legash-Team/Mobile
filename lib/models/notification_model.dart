class NotificationModel {
  final String id;
  final String hospitalName;
  final String bloodType;
  final int quantityNeeded;
  final bool isEmergency;
  final String? description;
  final String myResponseStatus;
  final String requestStatus;
  final DateTime notifiedAt;
  final DateTime? closesAt;

  NotificationModel({
    required this.id,
    required this.hospitalName,
    required this.bloodType,
    required this.quantityNeeded,
    this.isEmergency = false,
    this.description,
    required this.myResponseStatus,
    required this.requestStatus,
    required this.notifiedAt,
    this.closesAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String,
        hospitalName: json['hospitalName'] as String,
        bloodType: json['bloodType'] as String,
        quantityNeeded: json['quantityNeeded'] as int,
        isEmergency: json['isEmergency'] as bool? ?? false,
        description: json['description'] as String?,
        myResponseStatus: json['myResponseStatus'] as String,
        requestStatus: json['requestStatus'] as String,
        notifiedAt: DateTime.parse(json['notifiedAt'] as String),
        closesAt: json['closesAt'] != null
            ? DateTime.parse(json['closesAt'] as String)
            : null,
      );

  NotificationModel copyWith({
    String? myResponseStatus,
    String? requestStatus,
  }) {
    return NotificationModel(
      id: id,
      hospitalName: hospitalName,
      bloodType: bloodType,
      quantityNeeded: quantityNeeded,
      isEmergency: isEmergency,
      description: description,
      myResponseStatus: myResponseStatus ?? this.myResponseStatus,
      requestStatus: requestStatus ?? this.requestStatus,
      notifiedAt: notifiedAt,
      closesAt: closesAt,
    );
  }

  bool get isPending => myResponseStatus == 'pending';
  bool get isOpen => requestStatus == 'open';
  bool get isAccepted => myResponseStatus == 'accepted';
  bool get isDenied => myResponseStatus == 'denied';
  bool get isClosed => requestStatus == 'closed';
}