import '../../../../core/error/exceptions.dart';
import '../../../../shared/services/database/db_helper.dart';
import '../../../../shared/services/database/sqlite_service.dart';
import '../models/check_in_model.dart';

abstract interface class ICheckInLocalDatasource {
  Future<CheckInModel> insert(CheckInModel model);
  Future<List<CheckInModel>> getByStudentId(String studentId);
  Future<CheckInModel?> getLatestByStudentId(String studentId);
}

class CheckInLocalDatasource implements ICheckInLocalDatasource {
  final SqliteService _sqlite;

  const CheckInLocalDatasource(this._sqlite);

  @override
  Future<CheckInModel> insert(CheckInModel model) async {
    final newId = await _sqlite.insert(
      DbHelper.tableAttendance,
      model.toMap(),
    );
    if (newId == 0) {
      throw const LocalStorageException('Insert returned 0 — write failed');
    }
    // Return the model with the generated local ID
    return CheckInModel.fromEntity(
      CheckInModel(
        id: newId,
        studentId: model.studentId,
        checkInTime: model.checkInTime,
        gpsLatitude: model.gpsLatitude,
        gpsLongitude: model.gpsLongitude,
        previousTopic: model.previousTopic,
        expectedTopic: model.expectedTopic,
        mood: model.mood,
        qrCode: model.qrCode,
      ),
    );
  }

  @override
  Future<List<CheckInModel>> getByStudentId(String studentId) async {
    final rows = await _sqlite.queryWhere(
      DbHelper.tableAttendance,
      where: '${DbHelper.colStudentId} = ?',
      whereArgs: [studentId],
      orderBy: '${DbHelper.colCheckInTime} DESC',
    );
    return rows.map(CheckInModel.fromMap).toList();
  }

  @override
  Future<CheckInModel?> getLatestByStudentId(String studentId) async {
    final rows = await _sqlite.queryWhere(
      DbHelper.tableAttendance,
      where: '${DbHelper.colStudentId} = ?',
      whereArgs: [studentId],
      orderBy: '${DbHelper.colCheckInTime} DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return CheckInModel.fromMap(rows.first);
  }
}
