class DonorModel {
  final String name;
  final String password;
  final String phone;
  final String fin;
  final String gender;
  final String? bloodType;
  final double lat;
  final double lng;
  final bool agreedToTerms;

  DonorModel({
    required this.name,
    required this.password,
    required this.phone,
    required this.fin,
    required this.gender,
    this.bloodType,
    required this.lat,
    required this.lng,
    required this.agreedToTerms,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'password': password,
      'phone': phone,
      'fin': fin,
      'gender': gender,
      'location': {
        'lat': lat,
        'lng': lng,
      },
      'agreedToTerms': agreedToTerms,
    };
    if (bloodType != null && bloodType!.isNotEmpty) {
      map['bloodType'] = bloodType;
    }
    return map;
  }
}

class DonorInfo {
  final String id;
  final String name;
  final String phone;

  DonorInfo({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory DonorInfo.fromJson(Map<String, dynamic> json) {
    return DonorInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
    );
  }
}