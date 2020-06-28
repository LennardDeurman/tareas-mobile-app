import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/extensions/overlay_manager.dart';
import 'package:tareas/extensions/translation_keys.dart';
import 'package:tareas/widgets/cells/task.dart';
import 'package:tareas/widgets/dialogs/preferences_dialog.dart';
import 'package:tareas/widgets/headings/open_tasks_page_heading_box.dart';
import 'package:tareas/widgets/text_with_icon.dart';


class OpenTasksPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _OpenTasksPageState();
  }

}


class _OpenTasksPageState extends State<OpenTasksPage> {

  GlobalKey _headingBoxKey = GlobalKey();
  GlobalKey _headingBoxContainerKey = GlobalKey();

  OverlayManager _overlayManager;

  @override
  void initState() {
    super.initState();
    _overlayManager = OverlayManager(
      headingBoxContainerKey: _headingBoxContainerKey
    );

  }

  OpenTasksPageHeadingBox get headingBoxWidget {
    return _headingBoxKey.currentWidget;
  }

  void _showActionDialog({ GlobalKey<TextWithIconState> actionKey, OverlayBuilder builder }) {
    actionKey.currentState.active = true;
    _overlayManager.presentOverlay(context, builder: builder, onDismiss: () {
      actionKey.currentState.active = false;
    });
  }

  void _onCalendarPressed() {
    _showActionDialog(
      actionKey: headingBoxWidget.calendarActionKey,
      builder: (BuildContext context) {
        return Container();
      }
    );
  }

  void _onPreferencesPressed() {
    _showActionDialog(
        actionKey: headingBoxWidget.preferencesActionKey,
        builder: (BuildContext context) {
          return PreferencesDialog();
        }
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
          Container(child: OpenTasksPageHeadingBox(
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
            child: Stack(
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 1));
                  },
                  child: ListView.builder(itemBuilder: (BuildContext context, int position) {
                    return TaskCell();
                  }, itemCount: 5),
                )
              ],
            )
          )
        ],
      ),
    );
  }

}