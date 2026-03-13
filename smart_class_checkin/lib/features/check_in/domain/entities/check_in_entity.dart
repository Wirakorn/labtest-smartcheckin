import 'package:equatable/equatable.dart';

/// Pure-Dart domain entity – no Flutter, no Firebase, no sqflite.
/// Represents a completed check-in action by a student.
class CheckInEntity extends Equatable {
  final int? id; // null until persisted locally
  final String studentId;
  final DateTime checkInTime;
  final double gpsLatitude;
  final double gpsLongitude;
  final String previousTopic;
  final String expectedTopic;
  final int mood; // 1–5
  final String qrCode; // raw value from QR scan

  const CheckInEntity({
    this.id,
    required this.studentId,
    required this.checkInTime,
    required this.gpsLatitude,
    required this.gpsLongitude,
    required this.previousTopic,
    required this.expectedTopic,
    required this.mood,
    required this.qrCode,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        checkInTime,
        gpsLatitude,
        gpsLongitude,
        previousTopic,
        expectedTopic,
        mood,
        qrCode,
      ];
}
