import 'package:equatable/equatable.dart';

/// Domain entity for the "Finish Class" action.
/// Links back to the original check-in via [checkInId].
class CheckOutEntity extends Equatable {
  final int? id;
  final int checkInId; // FK → attendance.id
  final String studentId;
  final DateTime checkOutTime;
  final double gpsLatitude;
  final double gpsLongitude;
  final String learnedToday;
  final String feedback;
  final int postClassMood;
  final String qrCode;

  const CheckOutEntity({
    this.id,
    required this.checkInId,
    required this.studentId,
    required this.checkOutTime,
    required this.gpsLatitude,
    required this.gpsLongitude,
    required this.learnedToday,
    required this.feedback,
    required this.postClassMood,
    required this.qrCode,
  });

  @override
  List<Object?> get props => [
        id,
        checkInId,
        studentId,
        checkOutTime,
        gpsLatitude,
        gpsLongitude,
        learnedToday,
        feedback,
        postClassMood,
        qrCode,
      ];
}
