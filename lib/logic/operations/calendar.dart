import 'package:tareas/logic/operations/abstract.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/models/calendar.dart';
import 'package:tareas/network/calendar.dart';
import 'package:tareas/network/auth/service.dart';

class CalendarOverviewOperation extends Operation {

  final DateTime startDate;
  final DateTime endDate;
  final List<Category> categories;
  final bool certifiedOnly;

  CalendarOverviewOperation ({ this.startDate, this.endDate, this.categories, this.certifiedOnly = true });

  @override
  Future perform() async {
    CalendarOverviewFetcher calendarOverviewFetcher = CalendarOverviewFetcher();
    CalendarOverviewResult value = await calendarOverviewFetcher.getResult(
        certifiedOnly: this.certifiedOnly,
        certifiedUserId: AuthService().identityResult.activeMember.id,
        categories: categories,
        startDate: this.startDate,
        endDate: this.endDate
    );
    return value;
  }

}

