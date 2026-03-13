import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/check_out_entity.dart';
import '../../domain/repositories/i_check_out_repository.dart';
import '../datasources/check_out_local_datasource.dart';
import '../datasources/check_out_remote_datasource.dart';
import '../models/check_out_model.dart';

class CheckOutRepositoryImpl implements ICheckOutRepository {
  final ICheckOutLocalDatasource _local;
  final ICheckOutRemoteDatasource _remote;

  const CheckOutRepositoryImpl({
    required ICheckOutLocalDatasource local,
    required ICheckOutRemoteDatasource remote,
  })  : _local = local,
        _remote = remote;

  @override
  Future<Either<Failure, CheckOutEntity>> saveCheckOut(
      CheckOutEntity entity) async {
    try {
      final model = CheckOutModel.fromEntity(entity);
      final saved = await _local.update(model);

      try {
        await _remote.push(saved);
      } on RemoteException {
        // Best-effort — local save already succeeded
      }

      return Right(saved);
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    } catch (e) {
      return Left(LocalStorageFailure('Unexpected error: $e'));
    }
  }
}
