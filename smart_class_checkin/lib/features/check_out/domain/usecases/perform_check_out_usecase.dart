import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/check_out_entity.dart';
import '../repositories/i_check_out_repository.dart';

class PerformCheckOutUseCase {
  final ICheckOutRepository _repository;

  const PerformCheckOutUseCase(this._repository);

  Future<Either<Failure, CheckOutEntity>> call(CheckOutEntity entity) {
    if (entity.learnedToday.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('learnedToday is required')),
      );
    }
    if (entity.postClassMood < 1 || entity.postClassMood > 5) {
      return Future.value(
        const Left(ValidationFailure('postClassMood must be between 1 and 5')),
      );
    }
    return _repository.saveCheckOut(entity);
  }
}
