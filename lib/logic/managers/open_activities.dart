import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import 'package:tareas/logic/datepair.dart';
import 'package:tareas/logic/operations/open_activities.dart';
import 'package:tareas/logic/delegates/selection.dart';
import 'package:tareas/logic/delegates/loading.dart';
import 'package:tareas/logic/providers/open_activities.dart';
import 'package:tareas/logic/providers/calendar.dart';
import 'package:tareas/models/category.dart';


class OpenActivitiesDownloader {

  final OpenActivitiesProvider openActivitiesProvider = OpenActivitiesProvider();

  OpenActivitiesGlobalSyncOperation _openActivitiesGlobalSyncOperation;

  List<Category> categories = [];

  ValueNotifier<OpenActivitiesResult> notifier = ValueNotifier<OpenActivitiesResult>(null);

  LoadingDelegate loadingDelegate =  LoadingDelegate();

  OpenActivitiesDownloader ();

  Future load({ DateTime dateTime }) async {
    if (_openActivitiesGlobalSyncOperation != null) {
      _openActivitiesGlobalSyncOperation.cancel();
    }

    if (dateTime == null)
      dateTime = DatePair(DateTime.now()).endDate;

    _openActivitiesGlobalSyncOperation = OpenActivitiesGlobalSyncOperation(dateTime, openActivitiesProvider, categories);
    _openActivitiesGlobalSyncOperation.onCancel = () {
      loadingDelegate.isLoading = false;
    };

    loadingDelegate.isLoading = true;
    return await _openActivitiesGlobalSyncOperation.execute().whenComplete(() {
      var value = this.openActivitiesProvider.getResult(); //Should be called also when an error is thrown
      notifier.value = value;
      loadingDelegate.isLoading = false;
    });
  }

  void unloadExisting() {
    notifier.value = null;
    openActivitiesProvider.unloadAll();
    if (_openActivitiesGlobalSyncOperation != null)
        _openActivitiesGlobalSyncOperation.cancel();
  }

}

class OpenActivitiesManager {

  final SelectionDelegate<Category> categoriesSelectionDelegate = SelectionDelegate<Category>();
  final SingleSelectionDelegate<DateTime> calendarSelectionDelegate = SingleSelectionDelegate<DateTime>(DateTime.now());
  final CalendarOverviewProvider  calendarOverviewProvider = CalendarOverviewProvider();
  final OpenActivitiesDownloader openActivitiesDownloader = OpenActivitiesDownloader();

  Future lookUpBySelectedDate() async {
    return openActivitiesDownloader.load(dateTime: calendarSelectionDelegate.selectedObject);
  }

  Future refreshOpenActivities() async {
    openActivitiesDownloader.unloadExisting();
    return openActivitiesDownloader.load(dateTime: DatePair(calendarSelectionDelegate.selectedObject).endDate);
  }

  Future refreshCalendar() async {
    calendarOverviewProvider.unloadExisting();
    return calendarOverviewProvider.load();
  }

  Future updateCategories(List<Category> categories) async {
    categoriesSelectionDelegate.selectedObjects = categories;
    calendarOverviewProvider.categories = categories;
    openActivitiesDownloader.categories = categories;

    return Future.wait(
      [
        refreshCalendar(),
        refreshOpenActivities()
      ]
    );
  }
}