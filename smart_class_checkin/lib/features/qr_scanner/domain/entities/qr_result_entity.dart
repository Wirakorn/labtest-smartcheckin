import 'package:equatable/equatable.dart';

/// Domain entity representing a successfully-scanned QR code.
class QrResultEntity extends Equatable {
  final String rawValue;
  final DateTime scannedAt;

  const QrResultEntity({
    required this.rawValue,
    required this.scannedAt,
  });

  @override
  List<Object?> get props => [rawValue, scannedAt];
}
