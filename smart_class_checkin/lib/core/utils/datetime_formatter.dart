import 'package:intl/intl.dart';

class DateTimeFormatter {
  DateTimeFormatter._();

  static final _dateFormat = DateFormat('dd/MM/yyyy', 'th');
  static final _timeFormat = DateFormat('HH:mm', 'th');
  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm', 'th');

  /// Returns "13/03/2569" (Thai Buddhist Era date)
  static String toThaiDate(DateTime dt) => _dateFormat.format(dt);

  /// Returns "09:30"
  static String toTime(DateTime dt) => _timeFormat.format(dt);

  /// Returns "13/03/2569 09:30"
  static String toThaiDateTime(DateTime dt) => _dateTimeFormat.format(dt);

  /// Returns ISO-8601 string – used for SQLite/Firestore storage
  static String toIso(DateTime dt) => dt.toIso8601String();

  /// Parses ISO-8601 string from storage back to DateTime
  static DateTime fromIso(String iso) => DateTime.parse(iso);
}
