class BloodCenterModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String address;
  final double lat;
  final double lng;
  final String? licenseNumber;
  final String status;
  double? distanceKm;

  BloodCenterModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.address,
    required this.lat,
    required this.lng,
    this.licenseNumber,
    this.status = 'Open for Donations',
    this.distanceKm,
  });

  factory BloodCenterModel.fromJson(Map<String, dynamic> json) {
    return BloodCenterModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: json['name'] as String? ?? json['hospitalName'] as String? ?? 'Verified Blood Center',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      address: json['address'] as String? ?? 'Addis Ababa, Ethiopia',
      lat: (json['lat'] as num?)?.toDouble() ?? 9.03,
      lng: (json['lng'] as num?)?.toDouble() ?? 38.75,
      licenseNumber: json['licenseNumber'] as String?,
      status: json['status'] as String? ?? 'Open for Donations',
    );
  }
}
