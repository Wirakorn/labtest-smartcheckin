// Exceptions thrown in the data layer.
// These are caught by repository implementations and mapped to [Failure].
library;

class LocalStorageException implements Exception {
  final String message;
  const LocalStorageException([this.message = 'SQLite operation failed']);

  @override
  String toString() => 'LocalStorageException: $message';
}

class RemoteException implements Exception {
  final String message;
  const RemoteException([this.message = 'Firebase operation failed']);

  @override
  String toString() => 'RemoteException: $message';
}

class LocationException implements Exception {
  final String message;
  const LocationException([this.message = 'GPS location unavailable']);

  @override
  String toString() => 'LocationException: $message';
}

class QrScanException implements Exception {
  final String message;
  const QrScanException([this.message = 'QR scan failed']);

  @override
  String toString() => 'QrScanException: $message';
}
