import 'package:intl/intl.dart';
import 'package:tareas/models/abstract.dart';

class NetworkParams {

  static const String startDate = "startDate";
  static const String endDate = "endDate";
  static const String category = "category";
  static const String certifiedUserId = "certifiedUserId";
  static const String certifiedOnly = "certifiedOnly";
  static const String page = "page";

  static String dateString(DateTime dateTime) {
    if (dateTime != null) {
      DateFormat dateFormat = DateFormat("MM-dd-yyyy");
      return dateFormat.format(dateTime);
    }
    return null;
  }

  static String namedIdList(List<BaseObject> list) {
    return list.map((v) => v.id).toList().join(",");
  }

}