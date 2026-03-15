import 'package:intl/intl.dart';

class Formatters {
  static String compactInt(int value) {
    final formatter = NumberFormat.compact();
    return formatter.format(value);
  }

  static String shortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static String fullDate(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }

  static String time(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }
}
