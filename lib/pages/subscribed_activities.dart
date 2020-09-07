import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/logic/managers/subscribed_activities.dart';
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

  @override
  void initState() {
    super.initState();
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

}


