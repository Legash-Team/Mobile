class DonorModel {
  final String name;
  final String phone;
  final String fin;
  final String gender;
  final String? bloodType;
  final double lat;
  final double lng;
  final bool agreedToTerms;

  DonorModel({
    required this.name,
    required this.phone,
    required this.fin,
    required this.gender,
    this.bloodType,
    required this.lat,
    required this.lng,
    required this.agreedToTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'fin': fin,
      'gender': gender,
      'bloodType': (bloodType != null && bloodType!.isNotEmpty)
          ? bloodType
          : 'unknown',
      'location': {
        'lat': lat,
        'lng': lng,
      },
      'agreedToTerms': agreedToTerms,
    };
  }
}

class DonorInfo {
  final String id;
  final String name;
  final String phone;
  final String? bloodType;
  final String? fin;
  final String? gender;
  final num? weightKg;
  final num? heightCm;
  final String? healthNotes;
  final String? dob;

  DonorInfo({
    required this.id,
    required this.name,
    required this.phone,
    this.bloodType,
    this.fin,
    this.gender,
    this.weightKg,
    this.heightCm,
    this.healthNotes,
    this.dob,
  });

  factory DonorInfo.fromJson(Map<String, dynamic> json) {
    return DonorInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      bloodType: json['bloodType'] as String?,
      fin: json['fin'] as String?,
      gender: json['gender'] as String?,
      weightKg: json['weightKg'] as num?,
      heightCm: json['heightCm'] as num?,
      healthNotes: json['healthNotes'] as String?,
      dob: json['dob'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      if (bloodType != null) 'bloodType': bloodType,
      if (fin != null) 'fin': fin,
      if (gender != null) 'gender': gender,
      if (weightKg != null) 'weightKg': weightKg,
      if (heightCm != null) 'heightCm': heightCm,
      if (healthNotes != null) 'healthNotes': healthNotes,
      if (dob != null) 'dob': dob,
    };
  }
}
