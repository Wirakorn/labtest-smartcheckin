import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/check_in_entity.dart';
import '../../domain/repositories/i_check_in_repository.dart';
import '../datasources/check_in_local_datasource.dart';
import '../datasources/check_in_remote_datasource.dart';
import '../models/check_in_model.dart';

class CheckInRepositoryImpl implements ICheckInRepository {
  final ICheckInLocalDatasource _local;
  final ICheckInRemoteDatasource _remote;

  const CheckInRepositoryImpl({
    required ICheckInLocalDatasource local,
    required ICheckInRemoteDatasource remote,
  })  : _local = local,
        _remote = remote;

  @override
  Future<Either<Failure, CheckInEntity>> saveCheckIn(
      CheckInEntity entity) async {
    try {
      final model = CheckInModel.fromEntity(entity);

      // 1. Save locally first (source of truth)
      final saved = await _local.insert(model);

      // 2. Best-effort remote sync — do not fail the whole operation
      try {
        await _remote.push(saved);
      } on RemoteException {
        // Silently swallow: local save succeeded, remote will sync later
      }

      return Right(saved);
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    } catch (e) {
      return Left(LocalStorageFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CheckInEntity>>> getCheckIns(
      String studentId) async {
    try {
      final models = await _local.getByStudentId(studentId);
      return Right(models);
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    } catch (e) {
      return Left(LocalStorageFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, CheckInEntity?>> getLatestCheckIn(
      String studentId) async {
    try {
      final model = await _local.getLatestByStudentId(studentId);
      return Right(model);
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    } catch (e) {
      return Left(LocalStorageFailure('Unexpected error: $e'));
    }
  }
}
