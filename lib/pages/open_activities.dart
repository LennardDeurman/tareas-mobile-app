import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/logic/delegates/selection.dart';
import 'package:tareas/logic/managers/open_activities.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/ui/calendar.dart';
import 'package:tareas/ui/extensions/messages.dart';
import 'package:tareas/ui/extensions/presentation.dart';
import 'package:tareas/ui/extensions/dialogs.dart';
import 'package:tareas/ui/extensions/headers.dart';
import 'package:tareas/ui/extensions/labels.dart';
import 'package:tareas/ui/extensions/overlays.dart';
import 'package:tareas/ui/lists/open_activities.dart';


class OpenActivitiesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _OpenActivitiesPageState();
  }

}

class _OpenActivitiesHeaderManager {

  GlobalKey _headerKey = GlobalKey();
  GlobalKey _headerContainerKey = GlobalKey();

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

}

class _OpenActivitiesPageState extends State<OpenActivitiesPage> with _OpenActivitiesHeaderManager, AutomaticKeepAliveClientMixin {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<OpenActivitiesListState> openActivitiesListKey = GlobalKey<OpenActivitiesListState>();
  final OpenActivitiesManager manager = OpenActivitiesManager();
  LogoutPresenter _logoutPresenter;

  @override
  void initState() {

    manager.refreshOpenActivities();
    manager.refreshCalendar();

    manager.onOrganisationChange = () {
      openActivitiesListKey.currentState.refreshKey.currentState.show();
    };

    _overlayCreator = OverlayCreator(
      headerContainerKey: _headerContainerKey
    );

    _logoutPresenter = LogoutPresenter(
        context
    );
    _logoutPresenter.register();

    super.initState();
  }


  void _onCalendarPressed(BuildContext context) {
    _toggleActionDialog(
        buttonKey: headerWidget.calendarButtonKey,
        context: context,
        builder: (BuildContext context) {
          return Material(child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Calendar(
                    provider: manager.calendarOverviewProvider,
                    initialSelectedDay: manager.calendarSelectionDelegate.selectedObject,
                    onDateSelected: (DateTime date) async {
                      manager.calendarSelectionDelegate.selectedObject = date;

                      bool alreadyLoaded = openActivitiesListKey.currentState.isLoaded(date);
                      if (openActivitiesListKey.currentState != null) {
                        if (alreadyLoaded) {
                          openActivitiesListKey.currentState.scrollToNearest(date, withAnimation: false);
                        }
                      }

                      if (!alreadyLoaded) {
                        openActivitiesListKey.currentState.scrollToBottom(withAnimation: false);
                      }

                      Future.delayed(Duration(milliseconds: 500), () {
                        _overlayCreator.dismissOverlay();
                      });

                      var lookupFuture = manager.lookUpBySelectedDate().then((value) {
                        if (!alreadyLoaded) {
                          openActivitiesListKey.currentState.scrollToNearest(date);
                        }
                      }).catchError((e) {
                        showToast(
                            message: FlutterI18n.translate(context, TranslationKeys.errorLoadingMessage)
                        );
                      });

                      openActivitiesListKey.currentState.appendingItemsLoadingDelegate.attachFuture(lookupFuture);

                    }
                  )
                ),
              )
            ],

          ), color: Colors.transparent);
        }
    );
  }

  void _onPreferencesPressed(BuildContext context) {
    SelectionDelegate<Category> localSelectionDelegate = SelectionDelegate<Category>(
        selectedObjects: manager.categoriesSelectionDelegate.selectedObjects //Possible add objects from the manager class
    );
    _toggleActionDialog(
        buttonKey: headerWidget.preferencesButtonKey,
        context: context,
        builder: (BuildContext context) {
          return PreferencesDialog(
            selectionDelegate: localSelectionDelegate,
            onSave: () {
              manager.updateCategories(localSelectionDelegate.selectedObjects);
              _overlayCreator.dismissOverlay();
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
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
            child: OpenActivitiesList(
              manager,
              key: openActivitiesListKey
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
    manager.dispose();
    _logoutPresenter.unregister();
    super.dispose();
  }

}