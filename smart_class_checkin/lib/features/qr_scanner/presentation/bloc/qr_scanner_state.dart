import 'package:equatable/equatable.dart';
import '../../domain/entities/qr_result_entity.dart';

abstract class QrScannerState extends Equatable {
  const QrScannerState();

  @override
  List<Object?> get props => [];
}

class QrScannerInitial extends QrScannerState {
  const QrScannerInitial();
}

class QrScannerScanning extends QrScannerState {
  const QrScannerScanning();
}

class QrScannerSuccess extends QrScannerState {
  final QrResultEntity result;
  const QrScannerSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class QrScannerFailureState extends QrScannerState {
  final String message;
  const QrScannerFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
