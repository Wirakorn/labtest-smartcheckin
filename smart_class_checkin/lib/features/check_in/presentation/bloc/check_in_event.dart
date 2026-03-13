import 'package:equatable/equatable.dart';

abstract class CheckInEvent extends Equatable {
  const CheckInEvent();

  @override
  List<Object?> get props => [];
}

/// User pressed "Check-in" — triggers GPS + QR flow then waits for form submit.
class CheckInStarted extends CheckInEvent {
  const CheckInStarted();
}

/// GPS location was successfully acquired by the presentation layer.
class CheckInLocationAcquired extends CheckInEvent {
  final double latitude;
  final double longitude;

  const CheckInLocationAcquired({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

/// QR code was successfully scanned.
class CheckInQrScanned extends CheckInEvent {
  final String qrCode;

  const CheckInQrScanned(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}

/// User filled in the pre-class form and tapped "Confirm check-in".
class CheckInFormSubmitted extends CheckInEvent {
  final String studentId;
  final String previousTopic;
  final String expectedTopic;
  final int mood;

  const CheckInFormSubmitted({
    required this.studentId,
    required this.previousTopic,
    required this.expectedTopic,
    required this.mood,
  });

  @override
  List<Object?> get props => [studentId, previousTopic, expectedTopic, mood];
}

/// User dismissed the error snackbar / wants to retry from scratch.
class CheckInReset extends CheckInEvent {
  const CheckInReset();
}
