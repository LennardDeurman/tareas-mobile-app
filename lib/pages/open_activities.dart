import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/ui/extensions/dialogs.dart';
import 'package:tareas/ui/extensions/headers.dart';
import 'package:tareas/ui/extensions/labels.dart';
import 'package:tareas/ui/extensions/overlays.dart';


class OpenActivitiesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _OpenActivitiesPageState();
  }

}

class _OpenActivitiesHeaderManager {

  GlobalKey _headingBoxKey = GlobalKey();
  GlobalKey _headingBoxContainerKey = GlobalKey();

  OverlayCreator _overlayCreator;

  OpenActivitiesHeader get headerWidget {
    return _headingBoxKey.currentWidget;
  }

  void _toggleActionDialog({ GlobalKey<TextWithIconState> actionKey, BuildContext context, OverlayBuilder builder }) {

    if (_overlayCreator.isActiveOverlay(actionKey.hashCode)) {
      _overlayCreator.dismissOverlay();
      return;
    }

    actionKey.currentState.active = true;
    _overlayCreator.presentOverlay(context, overlayCode: actionKey.hashCode, builder: builder, onDismiss: () {
      actionKey.currentState.active = false;
    });
  }

  void _onCalendarPressed(BuildContext context) {
    _toggleActionDialog(
        actionKey: headerWidget.calendarButtonKey,
        context: context,
        builder: (BuildContext context) {
          return Container();
        }
    );
  }

  void _onPreferencesPressed(BuildContext context) {
    _toggleActionDialog(
        actionKey: headerWidget.preferencesButtonKey,
        context: context,
        builder: (BuildContext context) {
          return PreferencesDialog();
        }
    );
  }
}

class _OpenActivitiesPageState extends State<OpenActivitiesPage> with _OpenActivitiesHeaderManager {


  @override
  void initState() {
    super.initState();

    _overlayCreator = OverlayCreator(
      headingBoxContainerKey: _headingBoxContainerKey
    );

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
          Container(child: OpenActivitiesHeader(
            key: _headingBoxKey,
            title: FlutterI18n.translate(context, TranslationKeys.openTasks),
            onCalendarPressed: _onCalendarPressed,
            onPreferencesPressed: _onPreferencesPressed,
          ), decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: BrandColors.inputColor
              )
            )
          ), padding: EdgeInsets.only(
            bottom: 10
          ), key: _headingBoxContainerKey),
          Expanded(
            child: OpenActivitiesList()
          )
        ],
      ),
    );
  }

}