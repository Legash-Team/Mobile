import 'package:geolocator/geolocator.dart';
import '../models/blood_center_model.dart';
import 'api_service.dart';

class BloodCenterService {
  static Future<List<BloodCenterModel>> getBloodCenters() async {
    final res = await ApiService.get('/api/donor/blood-centers');
    final data = res['centers'];
    if (data is! List) return [];

    final centers = data
        .whereType<Map<String, dynamic>>()
        .map(BloodCenterModel.fromJson)
        .toList();

    // Attempt to compute distances with user location if permission granted
    try {
      final hasPermission = await _hasLocationPermission();
      if (hasPermission) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
          ),
        );

        for (final c in centers) {
          final distanceMeters = Geolocator.distanceBetween(
            pos.latitude,
            pos.longitude,
            c.lat,
            c.lng,
          );
          c.distanceKm = double.parse((distanceMeters / 1000).toStringAsFixed(1));
        }

        // Sort by closest distance
        centers.sort((a, b) => (a.distanceKm ?? 9999).compareTo(b.distanceKm ?? 9999));
      }
    } catch (_) {
      // Gracefully continue without distance sorting
    }

    return centers;
  }

  static Future<bool> _hasLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }
}
