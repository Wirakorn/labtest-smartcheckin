import 'package:equatable/equatable.dart';

abstract class CheckOutEvent extends Equatable {
  const CheckOutEvent();

  @override
  List<Object?> get props => [];
}

/// User pressed "Finish Class" — triggers GPS + checkInId lookup + QR flow.
class CheckOutStarted extends CheckOutEvent {
  final String studentId;

  const CheckOutStarted({required this.studentId});

  @override
  List<Object?> get props => [studentId];
}

class CheckOutLocationAcquired extends CheckOutEvent {
  final double latitude;
  final double longitude;

  const CheckOutLocationAcquired({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class CheckOutQrScanned extends CheckOutEvent {
  final String qrCode;

  const CheckOutQrScanned(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}

/// User submitted the post-class reflection form.
class CheckOutFormSubmitted extends CheckOutEvent {
  final String studentId;
  final String learnedToday;
  final String feedback;
  final int postClassMood;

  const CheckOutFormSubmitted({
    required this.studentId,
    required this.learnedToday,
    required this.feedback,
    required this.postClassMood,
  });

  @override
  List<Object?> get props => [studentId, learnedToday, feedback, postClassMood];
}

class CheckOutReset extends CheckOutEvent {
  const CheckOutReset();
}
