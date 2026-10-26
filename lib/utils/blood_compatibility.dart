// lib/utils/blood_compatibility.dart
// Hardcoded ABO and Rh blood compatibility mappings for Legash mobile.
//
// Reference source: Backend/src/utils/bloodCompatibility.js
// This file mirrors the exact compatibility logic defined in the backend.
// Do not modify the Backend file; this local constant utility provides offline-ready,
// client-side compatibility computation with zero network requests.

/// The 8 clinically recognized ABO / Rh blood types supported by Legash.
const List<String> supportedBloodTypes = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

// Alias for backwards/legacy compatibility
const List<String> SUPPORTED_BLOOD_TYPES = supportedBloodTypes; // ignore: constant_identifier_names

/// Map of recipient blood type to compatible donor blood types that this recipient can receive from.
/// Exactly mirrors COMPATIBILITY_CHART from Backend/src/utils/bloodCompatibility.js.
const Map<String, List<String>> canReceiveFromMap = {
  'O-': ['O-'],
  'O+': ['O+', 'O-'],
  'A-': ['A-', 'O-'],
  'A+': ['A+', 'A-', 'O+', 'O-'],
  'B-': ['B-', 'O-'],
  'B+': ['B+', 'B-', 'O+', 'O-'],
  'AB-': ['AB-', 'A-', 'B-', 'O-'],
  'AB+': ['AB+', 'AB-', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-'],
};

// Alias for backwards/legacy compatibility
const Map<String, List<String>> CAN_RECEIVE_FROM = canReceiveFromMap; // ignore: constant_identifier_names

/// Map of donor blood type to recipient blood types that can safely receive this donor's blood.
/// Inversely derived from Backend/src/utils/bloodCompatibility.js COMPATIBILITY_CHART:
/// R can receive from D <=> canReceiveFromMap[R].contains(D).
const Map<String, List<String>> canDonateToMap = {
  'O-': ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'],
  'O+': ['O+', 'A+', 'B+', 'AB+'],
  'A-': ['A-', 'A+', 'AB-', 'AB+'],
  'A+': ['A+', 'AB+'],
  'B-': ['B-', 'B+', 'AB-', 'AB+'],
  'B+': ['B+', 'AB+'],
  'AB-': ['AB-', 'AB+'],
  'AB+': ['AB+'],
};

// Alias for backwards/legacy compatibility
const Map<String, List<String>> CAN_DONATE_TO = canDonateToMap; // ignore: constant_identifier_names

/// Returns true if the provided blood type string matches one of the 8 supported types.
bool isBloodTypeKnown(String? bloodType) {
  if (bloodType == null) return false;
  final normalized = bloodType.trim().toUpperCase();
  return supportedBloodTypes.contains(normalized);
}

/// Normalizes a blood type string to uppercase or returns null if unknown.
String? normalizeBloodType(String? bloodType) {
  if (bloodType == null) return null;
  final normalized = bloodType.trim().toUpperCase();
  return supportedBloodTypes.contains(normalized) ? normalized : null;
}

/// Returns the list of blood types this donor can safely donate to.
List<String> getCanDonateTo(String? bloodType) {
  final normalized = normalizeBloodType(bloodType);
  if (normalized == null) return const [];
  return canDonateToMap[normalized] ?? const [];
}

/// Returns the list of blood types this recipient can safely receive from.
List<String> getCanReceiveFrom(String? bloodType) {
  final normalized = normalizeBloodType(bloodType);
  if (normalized == null) return const [];
  return canReceiveFromMap[normalized] ?? const [];
}
