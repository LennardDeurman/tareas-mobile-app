import 'package:tareas/models/category.dart';
import 'package:tareas/network/abstract.dart';
import 'package:tareas/network/params.dart';
import 'package:tareas/models/calendar.dart';


class CalendarOverviewFetcher extends Fetcher {

  @override
  RequestHelper<CalendarOverviewResult> createRequestHelper() {
    return RequestHelper<CalendarOverviewResult>(toObject: (Map map) {
      return CalendarOverviewResult(map);
    });
  }

  Future<CalendarOverviewResult> getResult({ DateTime startDate, DateTime endDate, bool certifiedOnly, List<Category> categories, String certifiedUserId }) async {
    return await this.requestHelper.getSingle(url("openActivitiesCalendar", queryParams: {
      NetworkParams.startDate: NetworkParams.dateString(startDate),
      NetworkParams.endDate: NetworkParams.dateString(endDate),
      NetworkParams.certifiedOnly: certifiedOnly.toString(),
      NetworkParams.category: NetworkParams.namedIdList(categories),
      NetworkParams.certifiedUserId: certifiedUserId
    }));
  }

}