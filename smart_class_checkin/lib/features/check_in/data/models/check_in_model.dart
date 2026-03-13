import '../../domain/entities/check_in_entity.dart';
import '../../../../shared/services/database/db_helper.dart';

/// Data-layer representation of [CheckInEntity].
/// Handles JSON serialisation for SQLite and Firestore.
class CheckInModel extends CheckInEntity {
  const CheckInModel({
    super.id,
    required super.studentId,
    required super.checkInTime,
    required super.gpsLatitude,
    required super.gpsLongitude,
    required super.previousTopic,
    required super.expectedTopic,
    required super.mood,
    required super.qrCode,
  });

  // ── SQLite ────────────────────────────────────────────────
  factory CheckInModel.fromMap(Map<String, dynamic> map) {
    return CheckInModel(
      id: map[DbHelper.colId] as int?,
      studentId: map[DbHelper.colStudentId] as String,
      checkInTime: DateTime.parse(map[DbHelper.colCheckInTime] as String),
      gpsLatitude: (map[DbHelper.colCheckInLat] as num).toDouble(),
      gpsLongitude: (map[DbHelper.colCheckInLng] as num).toDouble(),
      previousTopic: map[DbHelper.colPreviousTopic] as String,
      expectedTopic: map[DbHelper.colExpectedTopic] as String,
      mood: map[DbHelper.colMood] as int,
      qrCode: map[DbHelper.colQrCheckIn] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DbHelper.colId: id,
      DbHelper.colStudentId: studentId,
      DbHelper.colCheckInTime: checkInTime.toIso8601String(),
      DbHelper.colCheckInLat: gpsLatitude,
      DbHelper.colCheckInLng: gpsLongitude,
      DbHelper.colPreviousTopic: previousTopic,
      DbHelper.colExpectedTopic: expectedTopic,
      DbHelper.colMood: mood,
      DbHelper.colQrCheckIn: qrCode,
    };
  }

  // ── Firestore ─────────────────────────────────────────────
  factory CheckInModel.fromFirestore(Map<String, dynamic> map, int? localId) {
    return CheckInModel(
      id: localId,
      studentId: map['studentId'] as String,
      checkInTime: DateTime.parse(map['checkInTime'] as String),
      gpsLatitude: (map['gpsLatitude'] as num).toDouble(),
      gpsLongitude: (map['gpsLongitude'] as num).toDouble(),
      previousTopic: map['previousTopic'] as String,
      expectedTopic: map['expectedTopic'] as String,
      mood: map['mood'] as int,
      qrCode: map['qrCheckIn'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'checkInTime': checkInTime.toIso8601String(),
      'gpsLatitude': gpsLatitude,
      'gpsLongitude': gpsLongitude,
      'previousTopic': previousTopic,
      'expectedTopic': expectedTopic,
      'mood': mood,
      'qrCheckIn': qrCode,
    };
  }

  // ── Factory from domain entity ────────────────────────────
  factory CheckInModel.fromEntity(CheckInEntity entity) {
    return CheckInModel(
      id: entity.id,
      studentId: entity.studentId,
      checkInTime: entity.checkInTime,
      gpsLatitude: entity.gpsLatitude,
      gpsLongitude: entity.gpsLongitude,
      previousTopic: entity.previousTopic,
      expectedTopic: entity.expectedTopic,
      mood: entity.mood,
      qrCode: entity.qrCode,
    );
  }
}
