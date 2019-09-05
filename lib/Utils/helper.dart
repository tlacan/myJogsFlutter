import 'package:intl/intl.dart';

class Helper {
  static bool isNullOrEmpty(String value) {
    if (value == null) {
      return true;
    }
    return value.isEmpty;
  }

  static String dateISO8601Short(DateTime date) {
    final length = 19;
    var result = date.toIso8601String();
    return "${result.substring(0, length)}Z";
  }

  static String shortDate(DateTime date) {
    final dateFormat = new DateFormat('dd/MM/yyyy');
    return dateFormat.format(date);
  }
}