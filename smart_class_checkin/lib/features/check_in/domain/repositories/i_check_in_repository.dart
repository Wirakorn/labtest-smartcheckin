import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/check_in_entity.dart';

/// Contract that the data layer must fulfil.
/// The domain layer depends only on this interface, never on the implementation.
abstract interface class ICheckInRepository {
  /// Saves [entity] locally (SQLite) and syncs to Firebase.
  /// Returns the persisted entity (with its local [id] filled in).
  Future<Either<Failure, CheckInEntity>> saveCheckIn(CheckInEntity entity);

  /// Returns list of all check-ins for a given [studentId], newest first.
  Future<Either<Failure, List<CheckInEntity>>> getCheckIns(String studentId);

  /// Returns the most recent check-in for [studentId], or null if none exist.
  Future<Either<Failure, CheckInEntity?>> getLatestCheckIn(String studentId);
}
