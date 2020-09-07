import 'package:intl/intl.dart';
class TimeString {

  final DateTime dateTime;

  TimeString (this.dateTime);

  String get value {
    return DateFormat("d MMMM HH:mm").format(dateTime);
  }



}

class FriendlyDateFormat {

  static String format(DateTime dateTime) {
    return TimeString(dateTime).value;
  }

}

class DateString {

  final DateTime dateTime;

  DateString (this.dateTime);

  String get value {
    return DateFormat("d MMMM yyyy").format(dateTime);
  }



}
