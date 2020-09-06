import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/custom_fonts.dart';
import 'package:tareas/logic/providers/calendar.dart';
import 'package:tareas/models/calendar.dart';

class Calendar extends StatefulWidget {

  final CalendarOverviewProvider provider;
  final Function(DateTime) onDateSelected;
  final DateTime initialSelectedDay;

  Calendar ({ @required this.provider, this.onDateSelected, this.initialSelectedDay });

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

  bool isEnabled(DateTime dateTime) {
    var now = DateTime.now();
    var startDateNow = DateTime(
        now.year,
        now.month,
        now.day
    );
    return dateTime.millisecondsSinceEpoch >= startDateNow.millisecondsSinceEpoch;
  }

  Widget dayCell (DateTime dateTime, { BoxDecoration decoration, TextStyle textStyle}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: decoration,
      alignment: Alignment.center,
      margin: EdgeInsets.all(6),
      child: Text(
        dateTime.day.toString(),
        style: textStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: widget.provider.notifier,
      builder: (BuildContext context, CalendarOverviewResult result, Widget widget) {
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
          initialSelectedDay: this.widget.initialSelectedDay,
          enabledDayPredicate: isEnabled,
          onDaySelected: (DateTime dateTime, events) {
            if (this.widget.onDateSelected != null)
              this.widget.onDateSelected(dateTime);
          },
          builders: CalendarBuilders(
            dayBuilder: (BuildContext context, DateTime dateTime, events) {

              if (!isEnabled(dateTime) ) {
                return dayCell(
                    dateTime,
                    textStyle: TextStyle(
                        color: Colors.grey
                    )
                );
              } else if (controller.isSelected(dateTime)) {
                return dayCell(
                    dateTime,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: BrandColors.primaryColor),
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    )
                );
              } else if (this.widget.provider.hasEvent(dateTime)) {
                return dayCell(
                    dateTime,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: BrandColors.lightCalendarEventColor.withOpacity(0.5)),
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600
                    )
                );
              } else {
                return dayCell(dateTime);
              }

            }
          ),

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
    );


  }

}