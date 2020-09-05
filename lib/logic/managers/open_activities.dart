import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import 'package:scoped_model/scoped_model.dart';
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
    _openActivitiesGlobalSyncOperation = OpenActivitiesGlobalSyncOperation(dateTime, openActivitiesProvider, categories);
    _openActivitiesGlobalSyncOperation.onCancel = () {
      loadingDelegate.isLoading = false;
    };

    loadingDelegate.isLoading = true;
    return await _openActivitiesGlobalSyncOperation.execute().then((_) {
      notifier.value = this.openActivitiesProvider.getResult();
    }).whenComplete(() {
      loadingDelegate.isLoading = false;
    });
  }

  void unloadExisting() {
    notifier.value = null;
    openActivitiesProvider.unloadAll();
    _openActivitiesGlobalSyncOperation.cancel();
  }

}

class OpenActivitiesManager extends Model {

  final SelectionDelegate<Category> categoriesSelectionDelegate = SelectionDelegate<Category>();
  final CalendarOverviewProvider  calendarOverviewProvider = CalendarOverviewProvider();
  final OpenActivitiesDownloader openActivitiesDownloader = OpenActivitiesDownloader();

  Future initialize() async {
    await calendarOverviewProvider.load();
    //await openActivitiesDownloader.load();
  }

  Future lookUpByDate(DateTime dateTime) async {
    await openActivitiesDownloader.load(dateTime: dateTime);
  }

  Future updateCategories(List<Category> categories) async {
    categoriesSelectionDelegate.selectedObjects = categories;
    calendarOverviewProvider.categories = categories;
    openActivitiesDownloader.categories = categories;

    calendarOverviewProvider.unloadExisting();
    await calendarOverviewProvider.load();

    openActivitiesDownloader.unloadExisting();
    await openActivitiesDownloader.load();
  }
}