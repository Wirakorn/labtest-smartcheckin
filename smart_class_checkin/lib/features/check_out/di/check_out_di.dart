import '../../../core/di/injection_container.dart';
import '../../../features/check_in/domain/repositories/i_check_in_repository.dart';
import '../data/datasources/check_out_local_datasource.dart';
import '../data/datasources/check_out_remote_datasource.dart';
import '../data/repositories/check_out_repository_impl.dart';
import '../domain/repositories/i_check_out_repository.dart';
import '../domain/usecases/perform_check_out_usecase.dart';
import '../presentation/bloc/check_out_bloc.dart';

void registerCheckOutDependencies() {
  // Datasources
  sl.registerLazySingleton<ICheckOutLocalDatasource>(
    () => CheckOutLocalDatasource(sl()),
  );
  sl.registerLazySingleton<ICheckOutRemoteDatasource>(
    () => CheckOutRemoteDatasource(sl()),
  );

  // Repository
  sl.registerLazySingleton<ICheckOutRepository>(
    () => CheckOutRepositoryImpl(
      local: sl<ICheckOutLocalDatasource>(),
      remote: sl<ICheckOutRemoteDatasource>(),
    ),
  );

  // UseCase
  sl.registerLazySingleton(
    () => PerformCheckOutUseCase(sl<ICheckOutRepository>()),
  );

  // BLoC (factory — new instance per page visit)
  sl.registerFactory(
    () => CheckOutBloc(
      performCheckOut: sl(),
      locationService: sl(),
      checkInRepository: sl<ICheckInRepository>(),
    ),
  );
}
