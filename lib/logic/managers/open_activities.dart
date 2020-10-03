import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import 'package:tareas/logic/datepair.dart';
import 'package:tareas/logic/managers/activities_base.dart';
import 'package:tareas/logic/operations/open_activities.dart';
import 'package:tareas/logic/delegates/selection.dart';
import 'package:tareas/logic/delegates/loading.dart';
import 'package:tareas/logic/providers/open_activities.dart';
import 'package:tareas/logic/providers/calendar.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/member.dart';
import 'package:tareas/network/auth/service.dart';


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

class OpenActivitiesManager extends ActivitiesManager {

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

  @override
  void onActivityNotificationReceived(Activity activity) {
    OpenActivitiesResult openActivitiesResult = openActivitiesDownloader.notifier.value;
    if (openActivitiesResult != null) {
      Activity existingActivity = openActivitiesResult.findById(activity.id);
      if (existingActivity != null) {
        existingActivity.parse(activity.toMap());
      } else {
        String myMemberId = AuthService().identityResult.activeMember.id;
        if (activity.slotInfo.unAssignedSlots.length > 0 &&
            activity.slotInfo.findSlot(myMemberId) == null &&
            activity.time.millisecondsSinceEpoch < openActivitiesResult.lastBlockDate.millisecondsSinceEpoch
        ) { //Make sure the user is not already assigned, there is a slot open, and it's in the block of the current result (only then it fullfils the requested data)
          List<Category> selectedCategories = categoriesSelectionDelegate.selectedObjects;
          if (selectedCategories != null && selectedCategories.length > 0) { //If the user has categories selected, then we should also take care of those categories
            Category taskCategory = activity.task.category;
            if (taskCategory != null && selectedCategories.contains(taskCategory)) {
              openActivitiesResult.insert(activity);
            }
          } else {
            openActivitiesResult.insert(activity);
          }
        }
      }
    }
    openActivitiesResult.sort();
  }

  @override
  void onMemberNotificationReceived(Member member) {
    super.onMemberNotificationReceived(member);
    openActivitiesDownloader.unloadExisting();
    calendarOverviewProvider.unloadExisting();

  }



}