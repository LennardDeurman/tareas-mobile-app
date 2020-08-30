import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/custom_fonts.dart';

class Calendar extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }

}

class CalendarState extends State<Calendar> {

  final CalendarController controller = CalendarController();

  TextStyle dayStyle() {
    return TextStyle(
      fontSize: 16,
      fontFamily: CustomFonts.openSans
    );
  }

  TextStyle daysOfWeekStyle() {
    return TextStyle(
        fontSize: 16,
        fontFamily: CustomFonts.openSans,
        fontWeight: FontWeight.w600,
        color: BrandColors.primaryColor
    );
  }

  String capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarController: controller,
      locale: "nl",
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: daysOfWeekStyle(),
        weekendStyle: daysOfWeekStyle(),
        dowTextBuilder: (DateTime datetime, locale) {
          String value = DateFormat.E(locale).format(datetime);
          return capitalize(value);
        }
      ),
      rowHeight: 42,
      enabledDayPredicate: (DateTime dateTime) {
        var now = DateTime.now();
        var startDateNow = DateTime(
          now.year,
          now.month,
          now.day
        );
        return dateTime.millisecondsSinceEpoch >= startDateNow.millisecondsSinceEpoch;
      },
      calendarStyle: CalendarStyle(
        highlightToday: false,
        selectedColor: BrandColors.primaryColor,
        outsideDaysVisible: false,
        weekendStyle: dayStyle(),
        weekdayStyle: dayStyle(),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          fontFamily: CustomFonts.openSans
        ),
        titleTextBuilder: (DateTime datetime, locale) {
          String value = DateFormat.yMMMM(locale).format(datetime);
          return capitalize(value);
        },
        headerMargin: EdgeInsets.zero
      ),
    );
  }

}