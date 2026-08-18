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
        hospitalName: json['hospitalName'] as String,
        bloodType: json['bloodType'] as String,
        quantityNeeded: json['quantityNeeded'] as int,
        myResponseStatus: json['myResponseStatus'] as String,
        requestStatus: json['requestStatus'] as String,
        notifiedAt: DateTime.parse(json['notifiedAt'] as String),
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
  bool get isDenied => myResponseStatus == 'denied';
  bool get isClosed => requestStatus == 'closed';
}