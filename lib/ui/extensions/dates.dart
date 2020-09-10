import 'package:intl/intl.dart';
class TimeString {

  final DateTime dateTime;

  TimeString (this.dateTime);

  String get value {
    return DateFormat("d MMMM HH:mm").format(dateTime);
  }



}

class FriendlyDateFormat {

  static String capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static String format(DateTime dateTime, { bool onlyDate = false, bool capitalize = true }) {
    String value;
    if (onlyDate) {
      value = DateFormat("EEEE d MMMM").format(dateTime);
    } else {
      value = TimeString(dateTime).value;
    }
    if (capitalize)
      value = FriendlyDateFormat.capitalize(value);
    return value;
  }

}

class DateString {

  final DateTime dateTime;

  DateString (this.dateTime);

  String get value {
    return DateFormat("d MMMM yyyy").format(dateTime);
  }



}
