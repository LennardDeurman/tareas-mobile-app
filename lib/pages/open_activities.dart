import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/activities.dart';
import 'package:tareas/ui/cells/activity.dart';
import 'package:tareas/ui/extensions/presentation.dart';
import 'package:tareas/ui/lists/fetcher_list.dart';
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

  GlobalKey _headerKey = GlobalKey();
  GlobalKey _headerContainerKey = GlobalKey();

  SelectionDelegate<Category> _categoriesSelectionDelegate = SelectionDelegate<Category>();

  OverlayCreator _overlayCreator;

  OpenActivitiesHeader get headerWidget {
    return _headerKey.currentWidget;
  }

  void _toggleActionDialog({ GlobalKey<TextWithIconState> buttonKey, BuildContext context, OverlayBuilder builder }) {

    if (_overlayCreator.isActiveOverlay(buttonKey.hashCode)) {
      _overlayCreator.dismissOverlay();
      return;
    }

    buttonKey.currentState.active = true;
    _overlayCreator.presentOverlay(context, overlayCode: buttonKey.hashCode, builder: builder, onDismiss: () {
      buttonKey.currentState.active = false;
    });
  }

  void _onCalendarPressed(BuildContext context) {
    _toggleActionDialog(
        buttonKey: headerWidget.calendarButtonKey,
        context: context,
        builder: (BuildContext context) {
          return Container();
        }
    );
  }

  void _onPreferencesPressed(BuildContext context) {
    SelectionDelegate<Category> localSelectionDelegate = SelectionDelegate<Category>(
      selectedObjects: _categoriesSelectionDelegate.selectedObjects //Possible add objects from the manager class
    );
    _toggleActionDialog(
        buttonKey: headerWidget.preferencesButtonKey,
        context: context,
        builder: (BuildContext context) {
          return PreferencesDialog(
            selectionDelegate: localSelectionDelegate,
            onSave: () {
              _categoriesSelectionDelegate.selectedObjects = localSelectionDelegate.selectedObjects;
              _overlayCreator.dismissOverlay();
            },
          );
        }
    );
  }
}

class _OpenActivitiesPageState extends State<OpenActivitiesPage> with _OpenActivitiesHeaderManager, AutomaticKeepAliveClientMixin {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ActivitiesFetcher _activitiesFetcher = ActivitiesFetcher();
  LogoutPresenter _logoutPresenter;

  @override
  void initState() {
    super.initState();

    _overlayCreator = OverlayCreator(
      headerContainerKey: _headerContainerKey
    );

    _logoutPresenter = LogoutPresenter(
        context
    );
    _logoutPresenter.register();
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
            key: _headerKey,
            title: FlutterI18n.translate(context, TranslationKeys.openTasks),
            onCalendarPressed: () {
              _onCalendarPressed(context);
            },
            onPreferencesPressed: () {
              _onPreferencesPressed(context);
            },
          ), decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: BrandColors.inputColor
              )
            )
          ), padding: EdgeInsets.only(
            bottom: 10
          ), key: _headerContainerKey),
          Expanded(
            child: FetcherList<Activity>(
              downloadFutureBuilder: () {
                //_categoriesSelectionDelegate.selectedObjects;
                return _activitiesFetcher.getOpenActivities();
              },
              scaffoldKey: _scaffoldKey,
              noResultsBackgroundBuilder: (BuildContext context) {
                return Container(
                  child: Center(
                    child: Text("No results!"),
                  ),
                );
              },
              errorBackgroundBuilder: (BuildContext context) {
                return Container(
                  child: Center(
                    child: Text("Error!"),
                  ),
                );
              },
              loadingBackgroundBuilder: (BuildContext context) {
                return Container(
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    )
                  ),
                );
              },
              itemBuilder: (context, activity) {
                return ActivityCell(
                  activity
                );
              }
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
    _logoutPresenter.unregister();
  }

}