import 'package:intl/intl.dart';
import 'package:tareas/models/abstract.dart';

class NetworkParams {

  static const String startDate = "startDate";
  static const String endDate = "endDate";
  static const String categories = "categories";
  static const String certifiedUserId = "certifiedUserId";
  static const String certifiedOnly = "certifiedOnly";
  static const String page = "page";
  static const String teams = "teams";
  static const String includeTeamlessActivities = "includeTeamlessActivities";

  static String dateString(DateTime dateTime) {
    if (dateTime != null) {
      DateFormat dateFormat = DateFormat("MM-dd-yyyy");
      return dateFormat.format(dateTime);
    }
    return null;
  }

  static String namedIdList(List<BaseObject> list) {
    return list.map((v) => v.toString()).toList().join(";");
  }

}