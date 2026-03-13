import '../../../core/di/injection_container.dart';
import '../data/datasources/check_in_local_datasource.dart';
import '../data/datasources/check_in_remote_datasource.dart';
import '../data/repositories/check_in_repository_impl.dart';
import '../domain/repositories/i_check_in_repository.dart';
import '../domain/usecases/perform_check_in_usecase.dart';
import '../presentation/bloc/check_in_bloc.dart';

void registerCheckInDependencies() {
  // Datasources
  sl.registerLazySingleton<ICheckInLocalDatasource>(
    () => CheckInLocalDatasource(sl()),
  );
  sl.registerLazySingleton<ICheckInRemoteDatasource>(
    () => CheckInRemoteDatasource(sl()),
  );

  // Repository
  sl.registerLazySingleton<ICheckInRepository>(
    () => CheckInRepositoryImpl(
      local: sl<ICheckInLocalDatasource>(),
      remote: sl<ICheckInRemoteDatasource>(),
    ),
  );

  // UseCase
  sl.registerLazySingleton(
    () => PerformCheckInUseCase(sl<ICheckInRepository>()),
  );

  // BLoC (factory — new instance per page visit)
  sl.registerFactory(
    () => CheckInBloc(
      performCheckIn: sl(),
      locationService: sl(),
    ),
  );
}
