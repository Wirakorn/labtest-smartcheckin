import 'package:equatable/equatable.dart';

abstract class QrScannerEvent extends Equatable {
  const QrScannerEvent();

  @override
  List<Object?> get props => [];
}

class QrScannerStarted extends QrScannerEvent {
  const QrScannerStarted();
}

class QrCodeDetected extends QrScannerEvent {
  final String rawValue;
  const QrCodeDetected(this.rawValue);

  @override
  List<Object?> get props => [rawValue];
}

class QrScannerReset extends QrScannerEvent {
  const QrScannerReset();
}
