class NotificationModel {
  final String id;
  final String hospitalName;
  final String bloodType;
  final int quantityNeeded;
  final String myResponseStatus;
  final String requestStatus;
  final DateTime notifiedAt;

  NotificationModel({
    required this.id,
    required this.hospitalName,
    required this.bloodType,
    required this.quantityNeeded,
    required this.myResponseStatus,
    required this.requestStatus,
    required this.notifiedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String,
        hospitalName: json['hospitalName'] ?? json['hospital_name'] ?? 'Hospital',
        bloodType: json['bloodType'] ?? json['blood_group'] ?? 'unknown',
        quantityNeeded: (json['quantityNeeded'] ?? json['quantity_needed'] ?? 1) as int,
        myResponseStatus: json['myResponseStatus'] ?? json['my_response_status'] ?? 'pending',
        requestStatus: json['requestStatus'] ?? json['request_status'] ?? 'open',
        notifiedAt: json['notifiedAt'] != null
            ? DateTime.parse(json['notifiedAt'] as String)
            : (json['created_at'] != null 
                ? DateTime.parse(json['created_at'] as String) 
                : DateTime.now()),
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
      myResponseStatus: myResponseStatus ?? this.myResponseStatus,
      requestStatus: requestStatus ?? this.requestStatus,
      notifiedAt: notifiedAt,
    );
  }

  bool get isPending => myResponseStatus == 'pending';
  bool get isOpen => requestStatus == 'open';
  bool get isAccepted => myResponseStatus == 'accepted';
  bool get isDenied => myResponseStatus == 'denied' || myResponseStatus == 'declined';
  bool get isClosed => requestStatus == 'closed';
}