import 'package:flutter/foundation.dart' hide Category;
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/models/calendar.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/network/calendar.dart';

class CalendarOverviewDataSource {

  List<Category> categories = [];

  DateTime _startDate;
  DateTime _endDate;

  final ValueNotifier<CalendarOverviewResult> notifier = ValueNotifier(null);

  CalendarOverviewDataSource () {
    this._startDate = DateTime.now();
    this._endDate = this._startDate.add(Duration(days: 365));
  }

  void unloadExisting() {
    notifier.value = null;
  }

  bool hasEvent(DateTime dateTime) {
    var result = notifier.value;
    if (result != null) {
        return result.eventCount(dateTime) > 0;
    }

    return false;
  }

  Future<CalendarOverviewResult> load() async {
    CalendarOverviewFetcher calendarOverviewFetcher = CalendarOverviewFetcher();
    CalendarOverviewResult value = await calendarOverviewFetcher.getResult(
      certifiedOnly: true,
      certifiedUserId: AuthService().identityResult.userInfo.memberId,
      categories: categories,
      startDate: this._startDate,
      endDate: this._endDate
    );
    notifier.value = value;
    return value;
  }



}

class OpenActivitiesManager extends Model {

  final SelectionDelegate<Category> categoriesSelectionDelegate = SelectionDelegate<Category>();
  final CalendarOverviewDataSource  calendarOverviewDataSource = CalendarOverviewDataSource();

  Future initialize() async {
    await calendarOverviewDataSource.load();
  }

  Future updateCategories(List<Category> categories) async {
    categoriesSelectionDelegate.selectedObjects = categories;
    calendarOverviewDataSource.categories = categories;
    calendarOverviewDataSource.unloadExisting();
    await calendarOverviewDataSource.load();
  }
}