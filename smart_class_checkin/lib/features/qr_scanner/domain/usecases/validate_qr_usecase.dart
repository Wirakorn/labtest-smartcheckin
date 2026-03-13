import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/qr_result_entity.dart';

/// Validates that the scanned QR value is non-empty.
/// Extend this use case when QR format validation rules are defined.
class ValidateQrUseCase {
  const ValidateQrUseCase();

  Either<Failure, QrResultEntity> call(String rawValue) {
    if (rawValue.trim().isEmpty) {
      return const Left(QrScanFailure('QR code value is empty'));
    }
    return Right(QrResultEntity(
      rawValue: rawValue.trim(),
      scannedAt: DateTime.now(),
    ));
  }
}
