class DonationModel {
  final String hospitalName;
  final DateTime date;
  final int volumeMl;
  final String type;

  DonationModel({
    required this.hospitalName,
    required this.date,
    required this.volumeMl,
    required this.type,
  });

  String get formattedAmount => '$volumeMl ml $type';
}

final List<DonationModel> mockDonations = [
  DonationModel(
    hospitalName: "St. Paul's Hospital",
    date: DateTime(2025, 10, 14),
    volumeMl: 450,
    type: 'Whole Blood',
  ),
  DonationModel(
    hospitalName: 'Black Lion Hospital',
    date: DateTime(2025, 7, 2),
    volumeMl: 450,
    type: 'Whole Blood',
  ),
  DonationModel(
    hospitalName: 'Tikur Anbessa Specialized Hospital',
    date: DateTime(2025, 3, 18),
    volumeMl: 500,
    type: 'Whole Blood',
  ),
  DonationModel(
    hospitalName: 'Yekatit 12 Hospital',
    date: DateTime(2024, 11, 9),
    volumeMl: 450,
    type: 'Whole Blood',
  ),
];