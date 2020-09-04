import 'package:tareas/models/abstract.dart';

class CalendarKeys {
  static const String day = "day";
  static const String days = "days";
  static const String month = "month";
  static const String year = "year";
  static const String count = "count";
  static const String activities = "activities";
}

class CalendarDay extends ParsableObject {

  int day;
  int month;
  int year;
  int count;
  List<String> activityIds = [];

  CalendarDay (Map map) : super(map);

  @override
  Map toMap() {
    return {
      CalendarKeys.day: day,
      CalendarKeys.month: month,
      CalendarKeys.year: year,
      CalendarKeys.count: count
    };
  }

  @override
  void parse(Map json) {

    day = json[CalendarKeys.day];
    month = json[CalendarKeys.month];
    year = json[CalendarKeys.year];
    count = json[CalendarKeys.count];

    List items = json[CalendarKeys.activities];
    if (items != null) {
      activityIds = items.map((value) {
        return value as String;
      }).toList();
    }

  }

}

class CalendarOverviewResult extends ParsableObject {

  List<CalendarDay> calendarDays;
  Map _calendarMap;

  CalendarOverviewResult (Map map) : super(map);

  @override
  Map toMap() {
    return {
      CalendarKeys.days: objectsMapList(
        calendarDays
      )
    };
  }

  int eventCount(DateTime dateTime) {
    var key = "${dateTime.year}-${dateTime.month}";
    if (_calendarMap.containsKey(key)) {
      Map monthSubMap = _calendarMap[key];
      if (monthSubMap.containsKey(dateTime.day)) {
        var itemsCount = monthSubMap[dateTime.day];
        return itemsCount;
      }
    }
    return 0;
  }

  void organizeMapStructure() {
    _calendarMap = {};

    for (CalendarDay calendarDay in this.calendarDays) {
      String key = "${calendarDay.year}-${calendarDay.month}";
      if (!_calendarMap.containsKey(key)) {
        _calendarMap[key] = {};
      }

      Map subMap = _calendarMap[key];
      if (!subMap.containsKey(calendarDay.day)) {
        subMap[calendarDay.day] = 0;
      }

      subMap[calendarDay.day] = subMap[calendarDay.day] + calendarDay.count;
    }
  }

  @override
  void parse(Map json) {
    this.calendarDays = parseList<CalendarDay>(json[CalendarKeys.days], toObject: (value) {
      return CalendarDay(value);
    });

    organizeMapStructure();

  }

}