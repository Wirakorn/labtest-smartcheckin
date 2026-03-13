import 'package:geolocator/geolocator.dart';
import '../../../core/error/exceptions.dart';

/// Wraps [geolocator] package.
/// All callers receive a [Position] or a thrown [LocationException].
class LocationService {
  /// Requests permission if needed, then returns current [Position].
  Future<Position> getCurrentPosition() async {
    await _ensurePermission();

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (e) {
      throw LocationException('Failed to get position: $e');
    }
  }

  // ── Permission helper ───────────────────────────────────
  Future<void> _ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException('Location permission permanently denied');
    }
  }
}
