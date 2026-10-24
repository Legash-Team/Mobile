class DonationRecord {
  final String id;
  final String centerName;
  final String? centerAddress;
  final String bloodType;
  final int quantityMl;
  final DateTime donatedAt;
  final String status; // 'completed', 'pending', 'cancelled'
  final String? note;

  DonationRecord({
    required this.id,
    required this.centerName,
    this.centerAddress,
    required this.bloodType,
    required this.quantityMl,
    required this.donatedAt,
    this.status = 'completed',
    this.note,
  });

  factory DonationRecord.fromJson(Map<String, dynamic> json) {
    return DonationRecord(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      centerName: json['centerName'] as String? ??
          json['hospitalName'] as String? ??
          json['center'] as String? ??
          'Blood Center',
      centerAddress: json['centerAddress'] as String? ?? json['address'] as String?,
      bloodType: json['bloodType'] as String? ??
          json['donorBloodType'] as String? ??
          json['requestBloodType'] as String? ??
          'Unknown',
      quantityMl: (json['quantityMl'] as num?)?.toInt() ??
          (json['quantity'] as num?)?.toInt() ??
          ((json['unitsCollected'] as num?)?.toInt() != null
              ? (json['unitsCollected'] as num).toInt() * 450
              : 450),
      donatedAt: json['donatedAt'] != null
          ? DateTime.tryParse(json['donatedAt'].toString()) ?? DateTime.now()
          : (json['donationDate'] != null
              ? DateTime.tryParse(json['donationDate'].toString()) ?? DateTime.now()
              : DateTime.now()),
      status: json['status'] as String? ??
          (json['outcome'] == 'donated' ? 'completed' : 'cancelled'),
      note: json['note'] as String? ?? json['thankYouMessage'] as String?,
    );
  }

  bool get isCompleted => status == 'completed';

  String get formattedDate {
    return '${donatedAt.day}/${donatedAt.month}/${donatedAt.year}';
  }

  String get formattedQuantity => '$quantityMl ml';
}
