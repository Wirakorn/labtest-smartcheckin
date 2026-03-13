import '../../../core/di/injection_container.dart';
import '../domain/usecases/validate_qr_usecase.dart';
import '../presentation/bloc/qr_scanner_bloc.dart';

void registerQrScannerDependencies() {
  sl.registerLazySingleton(() => const ValidateQrUseCase());

  sl.registerFactory(
    () => QrScannerBloc(validateQr: sl()),
  );
}
