import 'package:equatable/equatable.dart';
import '../../domain/entities/check_in_entity.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object?> get props => [];
}

/// Nothing has started yet.
class CheckInInitial extends CheckInState {
  const CheckInInitial();
}

/// Fetching GPS location.
class CheckInLocationLoading extends CheckInState {
  const CheckInLocationLoading();
}

/// GPS acquired — waiting for QR scan.
class CheckInAwaitingQr extends CheckInState {
  final double latitude;
  final double longitude;

  const CheckInAwaitingQr({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

/// QR scanned — show the pre-class form.
class CheckInFormReady extends CheckInState {
  final double latitude;
  final double longitude;
  final String qrCode;

  const CheckInFormReady({
    required this.latitude,
    required this.longitude,
    required this.qrCode,
  });

  @override
  List<Object?> get props => [latitude, longitude, qrCode];
}

/// Saving to SQLite / Firebase in progress.
class CheckInSaving extends CheckInState {
  const CheckInSaving();
}

/// Check-in persisted successfully.
class CheckInSuccess extends CheckInState {
  final CheckInEntity entity;

  const CheckInSuccess(this.entity);

  @override
  List<Object?> get props => [entity];
}

/// Something went wrong.
class CheckInFailureState extends CheckInState {
  final String message;

  const CheckInFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
