import 'package:get_it/get_it.dart';
import '../../shared/services/database/db_helper.dart';
import '../../shared/services/database/sqlite_service.dart';
import '../../shared/services/location/location_service.dart';
import '../../shared/services/firebase/firebase_service.dart';
import '../../features/check_in/di/check_in_di.dart';
import '../../features/check_out/di/check_out_di.dart';
import '../../features/qr_scanner/di/qr_scanner_di.dart';

final GetIt sl = GetIt.instance;

/// Call once in [main] before [runApp].
Future<void> initDependencies() async {
  // ── Infrastructure Services (Singletons) ──────────────────
  sl.registerLazySingleton<DbHelper>(() => DbHelper.instance);

  sl.registerLazySingleton<SqliteService>(
    () => SqliteService(helper: sl<DbHelper>()),
  );

  sl.registerLazySingleton<LocationService>(() => LocationService());

  sl.registerLazySingleton<FirebaseService>(() => FirebaseService());

  // ── Features ──────────────────────────────────────────────
  registerCheckInDependencies();
  registerQrScannerDependencies();
  registerCheckOutDependencies();
}
