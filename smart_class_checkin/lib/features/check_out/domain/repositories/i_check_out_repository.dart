import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/check_out_entity.dart';

abstract interface class ICheckOutRepository {
  /// Saves the checkout locally and syncs to Firebase.
  Future<Either<Failure, CheckOutEntity>> saveCheckOut(CheckOutEntity entity);
}
