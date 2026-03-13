/// Base class for all domain-level failures.
/// Used with [dartz.Either] as the Left value.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

// ── Local Storage ─────────────────────────────────────────
class LocalStorageFailure extends Failure {
  const LocalStorageFailure([super.message = 'Local storage error']);
}

// ── Remote / Firebase ──────────────────────────────────────
class RemoteFailure extends Failure {
  const RemoteFailure([super.message = 'Remote service error']);
}

// ── Location / GPS ────────────────────────────────────────
class LocationFailure extends Failure {
  const LocationFailure([super.message = 'Unable to get GPS location']);
}

class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure(
      [super.message = 'Location permission denied']);
}

// ── QR Code ───────────────────────────────────────────────
class QrScanFailure extends Failure {
  const QrScanFailure([super.message = 'QR scan failed or invalid']);
}

// ── Validation ────────────────────────────────────────────
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}
