import '../../domain/entities/check_out_entity.dart';
import '../../../../shared/services/database/db_helper.dart';

class CheckOutModel extends CheckOutEntity {
  const CheckOutModel({
    super.id,
    required super.checkInId,
    required super.studentId,
    required super.checkOutTime,
    required super.gpsLatitude,
    required super.gpsLongitude,
    required super.learnedToday,
    required super.feedback,
    required super.postClassMood,
    required super.qrCode,
  });

  // ── SQLite ────────────────────────────────────────────────
  /// Reads a full attendance row and maps the check-out fields.
  factory CheckOutModel.fromMap(Map<String, dynamic> map) {
    return CheckOutModel(
      id: map[DbHelper.colId] as int?,
      checkInId: map[DbHelper.colId] as int,
      studentId: map[DbHelper.colStudentId] as String,
      checkOutTime: DateTime.parse(map[DbHelper.colCheckOutTime] as String),
      gpsLatitude: (map[DbHelper.colCheckOutLat] as num).toDouble(),
      gpsLongitude: (map[DbHelper.colCheckOutLng] as num).toDouble(),
      learnedToday: map[DbHelper.colLearnedToday] as String,
      feedback: (map[DbHelper.colFeedback] as String?) ?? '',
      postClassMood: (map[DbHelper.colPostClassMood] as int?) ?? 3,
      qrCode: map[DbHelper.colQrCheckOut] as String,
    );
  }

  /// Returns only the columns that the check-out UPDATE touches.
  Map<String, dynamic> toUpdateMap() {
    return {
      DbHelper.colCheckOutTime: checkOutTime.toIso8601String(),
      DbHelper.colCheckOutLat: gpsLatitude,
      DbHelper.colCheckOutLng: gpsLongitude,
      DbHelper.colLearnedToday: learnedToday,
      DbHelper.colFeedback: feedback,
      DbHelper.colPostClassMood: postClassMood,
      DbHelper.colQrCheckOut: qrCode,
    };
  }

  // ── Firestore ─────────────────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'checkInId': checkInId,
      'checkOutTime': checkOutTime.toIso8601String(),
      'gpsLatitude': gpsLatitude,
      'gpsLongitude': gpsLongitude,
      'learnedToday': learnedToday,
      'feedback': feedback,
      'postClassMood': postClassMood,
      'qrCheckOut': qrCode,
    };
  }

  factory CheckOutModel.fromEntity(CheckOutEntity entity) {
    return CheckOutModel(
      id: entity.id,
      checkInId: entity.checkInId,
      studentId: entity.studentId,
      checkOutTime: entity.checkOutTime,
      gpsLatitude: entity.gpsLatitude,
      gpsLongitude: entity.gpsLongitude,
      learnedToday: entity.learnedToday,
      feedback: entity.feedback,
      postClassMood: entity.postClassMood,
      qrCode: entity.qrCode,
    );
  }
}
