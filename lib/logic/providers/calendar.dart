import 'package:flutter/foundation.dart' hide Category;
import 'package:tareas/logic/operations/calendar.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/models/calendar.dart';

class CalendarOverviewProvider {

  final ValueNotifier<CalendarOverviewResult> notifier = ValueNotifier(null);

  DateTime _startDate;
  DateTime _endDate;
  CalendarOverviewOperation _runningOperation;

  List<Category> categories = [];


  CalendarOverviewProvider () {
    this._startDate = DateTime.now();
    this._endDate = this._startDate.add(Duration(days: 365));
  }


  bool hasEvent(DateTime dateTime) {
    var result = notifier.value;
    if (result != null) {
      return result.eventCount(dateTime) > 0;
    }

    return false;
  }

  Future load() async {
    _runningOperation = CalendarOverviewOperation(
        startDate: this._startDate,
        endDate: this._endDate,
        certifiedOnly: true,
        categories: categories
    );
    return _runningOperation.execute().then((value) {
      notifier.value = value;
    });
  }

  void unloadExisting() {
    if (_runningOperation != null)
      _runningOperation.cancel();
    notifier.value = null;
  }

}