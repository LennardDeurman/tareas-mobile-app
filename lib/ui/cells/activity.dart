import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/icons.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/pages/activity_detail.dart';
import 'package:tareas/ui/extensions/dates.dart';
import 'package:tareas/ui/extensions/labels.dart';

class ActivityCell extends StatelessWidget {

  final Activity activity;
  final bool shouldShowSlotInfo;

  ActivityCell (this.activity, { this.shouldShowSlotInfo = true });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10
      ),
      decoration: BoxDecoration(
        color: BrandColors.listItemBackgroundColor,
        borderRadius: BorderRadius.circular(7)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return ActivityDetailPage(
                  activity
                );
              }
            ));
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 3),
                  child: FaIcon(
                    TareasIcons.categoryIcons[
                    activity.task.category.name
                    ],
                    size: 24,
                    color: BrandColors.iconColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(child: Text(
                              activity.name,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                            Visibility(child: Text(
                              "${activity.slotInfo.assignedSlots.length} / ${activity.slotInfo.count}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ), visible: shouldShowSlotInfo)
                          ],
                        ),
                        Visibility(child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            activity.shortDescription ?? "",
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                        ), visible: activity.shortDescription != null),
                        Row(children: [Container(
                          margin: EdgeInsets.only(
                              top: 3
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)
                          ),
                          padding: EdgeInsets.all(7),
                          child: TextWithIcon(
                            iconData: FontAwesomeIcons.clock,
                            textMargin: EdgeInsets.symmetric(
                                horizontal: 5
                            ),
                            iconMargin: EdgeInsets.symmetric(
                                horizontal: 3
                            ),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: activity.isSoon ? BrandColors.errorColor : Colors.black,
                            text: FriendlyDateFormat.format(activity.time),
                          ),
                        )])
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: 12
                    ),
                  ),
                )
              ],
            ),
          ),

        )
      )
    );
  }

}