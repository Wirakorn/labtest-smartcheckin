import '../../../../core/error/exceptions.dart';
import '../../../../shared/services/database/db_helper.dart';
import '../../../../shared/services/database/sqlite_service.dart';
import '../models/check_out_model.dart';

abstract interface class ICheckOutLocalDatasource {
  /// Updates the existing attendance row identified by [checkInId]
  /// with check-out data.
  Future<CheckOutModel> update(CheckOutModel model);
}

class CheckOutLocalDatasource implements ICheckOutLocalDatasource {
  final SqliteService _sqlite;

  const CheckOutLocalDatasource(this._sqlite);

  @override
  Future<CheckOutModel> update(CheckOutModel model) async {
    final affected = await _sqlite.update(
      DbHelper.tableAttendance,
      model.toUpdateMap(),
      where: '${DbHelper.colId} = ?',
      whereArgs: [model.checkInId],
    );
    if (affected == 0) {
      throw LocalStorageException(
          'No attendance row found for checkInId=${model.checkInId}');
    }
    return model;
  }
}
