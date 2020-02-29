import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/extensions/translation_keys.dart';
import 'package:tareas/widgets/backgrounds/no_subscribed_tasks.dart';
import 'package:tareas/widgets/page_heading_box.dart';

class SubscribedTasksPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SubscribedTasksPageState();
  }

}




class _SubscribedTasksPageState extends State<SubscribedTasksPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageHeadingBox(
            title: FlutterI18n.translate(context, TranslationKeys.subscribed),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
              },
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: NoSubscribedTasksBackground()
                  ),
                  ListView()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}



