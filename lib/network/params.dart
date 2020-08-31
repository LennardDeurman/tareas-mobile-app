import 'package:intl/intl.dart';

class NetworkParams {

  static const String startDate = "startDate";
  static const String endDate = "endDate";
  static const String category = "category";
  static const String certifiedUserId = "certifiedUserId";
  static const String certifiedOnly = "certifiedOnly";
  static const String page = "page";

  static String dateString(DateTime dateTime) {
    if (dateTime != null)
      return DateFormat.yMd("nl").format(dateTime);
    return null;
  }

}