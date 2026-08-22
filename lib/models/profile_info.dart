class ProfileInfo {
  final String name;
  final bool isVerified;
  final String bloodType;
  final String phone;
  final String fin;
  final String gender;
  final String location;
  final int searchRadiusKm;
  final String? dob;
  final num? weightKg;
  final num? heightCm;
  final String? healthNotes;

  const ProfileInfo({
    required this.name,
    required this.isVerified,
    required this.bloodType,
    required this.phone,
    required this.fin,
    required this.gender,
    required this.location,
    required this.searchRadiusKm,
    this.dob,
    this.weightKg,
    this.heightCm,
    this.healthNotes,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }
}