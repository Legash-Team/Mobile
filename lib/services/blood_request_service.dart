// import 'dart:convert';
// import 'package:http/http.dart' as http;

// enum RequestAction { accept, decline }

// class BloodRequestModel {
//   final String id;
//   final String patientName;
//   final String hospitalName;
//   final String bloodType;
//   final int unitsNeeded;
//   final String urgency; // 'CRITICAL', 'URGENT', 'NORMAL'
//   final DateTime createdAt;
//   String status; // 'pending', 'accepted', 'declined'

//   BloodRequestModel({
//     required this.id,
//     required this.patientName,
//     required this.hospitalName,
//     required this.bloodType,
//     required this.unitsNeeded,
//     required this.urgency,
//     required this.createdAt,
//     this.status = 'pending',
//   });

//   factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
//     return BloodRequestModel(
//       id: json['id'] ?? '',
//       patientName: json['patient_name'] ?? 'Anonymous Patient',
//       hospitalName: json['hospital_name'] ?? 'Unknown Hospital',
//       bloodType: json['blood_group'] ?? 'O+',
//       unitsNeeded: json['units_needed'] ?? 1,
//       urgency: (json['urgency'] ?? 'URGENT').toString().toUpperCase(),
//       createdAt: json['created_at'] != null 
//           ? DateTime.parse(json['created_at']) 
//           : DateTime.now(),
//       status: json['status'] ?? 'pending',
//     );
//   }
// }

// class BloodRequestService {
//   static const String baseUrl = 'https://api.legash.org/api/v1'; // Replace with your base API URL

//   // Respond to request: Accept or Decline
//   static Future<bool> respondToRequest({
//     required String requestId,
//     required String donorId,
//     required RequestAction action,
//     String? token,
//   }) async {
//     final actionString = action == RequestAction.accept ? 'accept' : 'decline';
//     final url = Uri.parse('$baseUrl/requests/$requestId/$actionString');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'donor_id': donorId,
//           'timestamp': DateTime.now().toIso8601String(),
//         }),
//       );

//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       // Fallback for offline or local mockup testing
//       return true;
//     }
//   }
// }