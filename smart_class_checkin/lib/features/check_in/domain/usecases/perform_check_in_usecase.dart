import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/check_in_entity.dart';
import '../repositories/i_check_in_repository.dart';

/// Single-responsibility use case: perform a student check-in.
///
/// Called by the BLoC with a fully-formed [CheckInEntity] (GPS + QR already
/// resolved by the presentation layer before invoking this use case).
class PerformCheckInUseCase {
  final ICheckInRepository _repository;

  const PerformCheckInUseCase(this._repository);

  Future<Either<Failure, CheckInEntity>> call(CheckInEntity entity) {
    if (entity.mood < 1 || entity.mood > 5) {
      return Future.value(
        const Left(ValidationFailure('Mood must be between 1 and 5')),
      );
    }
    if (entity.previousTopic.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Previous topic is required')),
      );
    }
    if (entity.expectedTopic.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Expected topic is required')),
      );
    }
    return _repository.saveCheckIn(entity);
  }
}
