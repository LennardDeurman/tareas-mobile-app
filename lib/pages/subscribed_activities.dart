import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/logic/delegates/activity_changes.dart';
import 'package:tareas/logic/managers/subscribed_activities.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/slot.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/ui/extensions/headers.dart';
import 'package:tareas/ui/lists/subscribed_activities.dart';

class SubscribedActivitiesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SubscribedActivitiesPageState();
  }

}

class _SubscribedActivitiesPageState extends State<SubscribedActivitiesPage> with AutomaticKeepAliveClientMixin {

  final SubscribedActivitiesManager subscribedActivitiesManager = SubscribedActivitiesManager();

  ActivityChangesHandler _handler;

  @override
  void initState() {
    super.initState();
    _handler = ActivityChangesHandler(
      onUpdate: (Activity activity) {
        SubscribedActivitiesResult subscribedActivitiesResult = subscribedActivitiesManager.notifier.value;
        if (subscribedActivitiesResult != null) {
          Activity existingActivity = subscribedActivitiesResult.findById(activity.id);
          if (existingActivity != null) {
            existingActivity.parse(activity.toMap());
          } else {
            String myMemberId = AuthService().identityResult.activeMember.id;
            Slot slot = activity.slotInfo.findSlot(myMemberId);
            if (slot != null && !slot.isCompleted) {
              subscribedActivitiesResult.insert(activity);
            }
          }
          subscribedActivitiesResult.sort();
        }
      },
    );

    ActivityChangesDelegate().register(
      handler: _handler
    );

    subscribedActivitiesManager.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageHeader(
            title: FlutterI18n.translate(context, TranslationKeys.subscribed),
            padding: EdgeInsets.only(left: 20, top: 15),
          ),
          Expanded(
              child: SubscribedActivitiesList(
                subscribedActivitiesManager
              )
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();

    ActivityChangesDelegate().unRegister(
      handler: _handler
    );
  }

}


