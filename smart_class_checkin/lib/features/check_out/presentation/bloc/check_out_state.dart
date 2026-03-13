import 'package:equatable/equatable.dart';
import '../../domain/entities/check_out_entity.dart';

abstract class CheckOutState extends Equatable {
  const CheckOutState();

  @override
  List<Object?> get props => [];
}

class CheckOutInitial extends CheckOutState {
  const CheckOutInitial();
}

class CheckOutLocationLoading extends CheckOutState {
  const CheckOutLocationLoading();
}

class CheckOutAwaitingQr extends CheckOutState {
  final double latitude;
  final double longitude;

  const CheckOutAwaitingQr({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class CheckOutFormReady extends CheckOutState {
  final double latitude;
  final double longitude;
  final String qrCode;

  const CheckOutFormReady({
    required this.latitude,
    required this.longitude,
    required this.qrCode,
  });

  @override
  List<Object?> get props => [latitude, longitude, qrCode];
}

class CheckOutSaving extends CheckOutState {
  const CheckOutSaving();
}

class CheckOutSuccess extends CheckOutState {
  final CheckOutEntity entity;

  const CheckOutSuccess(this.entity);

  @override
  List<Object?> get props => [entity];
}

class CheckOutFailureState extends CheckOutState {
  final String message;

  const CheckOutFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
