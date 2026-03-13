import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/validate_qr_usecase.dart';
import 'qr_scanner_event.dart';
import 'qr_scanner_state.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState> {
  final ValidateQrUseCase _validateQr;

  QrScannerBloc({required ValidateQrUseCase validateQr})
      : _validateQr = validateQr,
        super(const QrScannerInitial()) {
    on<QrScannerStarted>(_onStarted);
    on<QrCodeDetected>(_onDetected);
    on<QrScannerReset>(_onReset);
  }

  void _onStarted(QrScannerStarted event, Emitter<QrScannerState> emit) {
    emit(const QrScannerScanning());
  }

  void _onDetected(QrCodeDetected event, Emitter<QrScannerState> emit) {
    // Guard: ignore duplicate detections once already succeeded
    if (state is QrScannerSuccess) return;

    final result = _validateQr(event.rawValue);
    result.fold(
      (failure) => emit(QrScannerFailureState(failure.message)),
      (entity) => emit(QrScannerSuccess(entity)),
    );
  }

  void _onReset(QrScannerReset event, Emitter<QrScannerState> emit) {
    emit(const QrScannerScanning());
  }
}
