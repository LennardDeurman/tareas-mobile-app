import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/extensions/translation_keys.dart';
import 'package:tareas/widgets/headings/page_heading_box.dart';

class SubscribedActivitiesPage extends StatelessWidget {

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
            child: Container() //TODO: Create the SubscribedActivitiesListView
          )
        ],
      ),
    );
  }

}



