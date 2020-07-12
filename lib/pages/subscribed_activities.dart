import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/ui/extensions/headers.dart';

//TODO: Make this class also automatickeepaliveclientmixin and implement logout present

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
          PageHeader(
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



