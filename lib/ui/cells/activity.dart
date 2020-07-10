import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/ui/extensions/labels.dart';

class ActivityCell extends StatelessWidget {

  final Activity activity;

  ActivityCell (this.activity);


  String timeString(DateTime dateTime) {
    return DateFormat("d MMMM HH:mm").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: InkWell(child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: BrandColors.inputColor
          )
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  activity.task.name,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              TextWithIcon(
                iconData: FontAwesomeIcons.clock,
                text: timeString(activity.time),
                fontSize: 12,
                iconMargin: EdgeInsets.symmetric(
                  horizontal: 5
                ),
              )
            ],
          )
        ],
      ),
    ), onTap: () {

    }), color: Colors.white);
  }

}