import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tareas/logic/activities_result.dart';
import 'package:tareas/logic/completer.dart';
import 'package:tareas/logic/delegates/loading.dart';
import 'package:tareas/logic/managers/activities_base.dart';
import 'package:tareas/logic/operations/subscribed_activities.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/member.dart';
import 'package:tareas/models/slot.dart';
import 'package:tareas/network/auth/service.dart';

class SubscribedActivitiesSortedResult {

  List<DateTime> sectionKeys;
  List<List<Activity>> sectionItems;

  SubscribedActivitiesSortedResult ({ @required this.sectionKeys, @required this.sectionItems });

  int get numberOfSections {
    return sectionKeys.length;
  }

  int numberOfRows(int section) {
    return sectionItems[section].length;
  }

}

class SubscribedActivitiesResult extends ActivitiesResult {

  final CompletionResult<List<Activity>> completionResult;

  SubscribedActivitiesSortedResult _subscribedActivitiesSortedResult;

  SubscribedActivitiesSortedResult get sortedResult {
    return _subscribedActivitiesSortedResult;
  }

  SubscribedActivitiesResult (this.completionResult) {
    sort();
  }

  @override
  bool filter(Activity activity) {
    if (activity.isCompleted) {
      return false;
    }
    var slot = activity.slotInfo.findSlot(AuthService().identityResult.activeMember.id);
    if (slot != null) {
      if (slot.isCompleted) {
        return false;
      }
      return true;
    }

    return false;
  }

  @override
  void insert(Activity activity) {
    if (completionResult.result != null) {
      completionResult.result.add(activity);
    }
  }

  @override
  void sort() {
    List<DateTime> dates = [];
    List<List<Activity>> items = [];
    if (completionResult.result != null) {
      List<Activity> activities = completionResult.result;
      activities = activities.where(filter).toList();
      Map resultMap = Map<DateTime, List<Activity>>();
      for (Activity activity in activities) {
        DateTime dateTime = DateTime(
            activity.time.year,
            activity.time.month,
            activity.time.day
        );
        if (resultMap.containsKey(dateTime)) {
          List<Activity> activitiesInMap = resultMap[dateTime];
          activitiesInMap.add(
              activity
          );
          resultMap[dateTime] = activitiesInMap;
        } else {
          resultMap[dateTime] = [activity];
        }
      }

      dates = resultMap.keys.toList();
      dates.sort((a, b) => a.compareTo(b));

      for (DateTime dateTime in dates) {
        List<Activity> activities = resultMap[dateTime];
        items.add(activities);
      }

    }
    _subscribedActivitiesSortedResult = SubscribedActivitiesSortedResult(
        sectionKeys: dates,
        sectionItems: items
    );
  }

  @override
  Activity findById(String id) {
    return completionResult.result.firstWhere((activity) => activity.id == id, orElse: () {
      return null;
    });
  }


}


class SubscribedActivitiesManager extends ActivitiesManager {

  SubscribedActivitiesOperation _currentOperation;

  final ValueNotifier<SubscribedActivitiesResult> notifier = ValueNotifier<SubscribedActivitiesResult>(null);

  final LoadingDelegate loadingDelegate = LoadingDelegate();

  Future refresh({ bool force = false }) async {
    WorkCompleter<List<Activity>> workCompleter = WorkCompleter<List<Activity>>();
    Future workingFuture = workCompleter.future;
    loadingDelegate.attachFuture(workingFuture);
    try {
      if (_currentOperation != null && !force) {
        List<Activity> values = await _currentOperation.future;
        workCompleter.complete(values);
      } else {
        _currentOperation = SubscribedActivitiesOperation();
        List<Activity> values = await _currentOperation.execute();
        workCompleter.complete(values);
      }
    } catch (e) {
      workCompleter.completeError(e);
    }



    return workingFuture.whenComplete(() {
      var result = SubscribedActivitiesResult(workCompleter.completionResult);
      notifier.value = result;
    });
  }

  @override
  void onActivityNotificationReceived(Activity activity) {
    SubscribedActivitiesResult subscribedActivitiesResult = notifier.value;
    if (subscribedActivitiesResult != null) {
      Activity existingActivity = subscribedActivitiesResult.findById(activity.id);
      if (existingActivity != null) {
        existingActivity.parse(activity.toMap());
      } else {
        String myMemberId = AuthService().identityResult.activeMember.id;
        Slot slot = activity.slotInfo.findSlot(myMemberId);
        if (slot != null && !slot.isCompleted) {
          subscribedActivitiesResult.insert(activity); //Insert the new activity when the user has a slot and it's not completed
        }
      }
      subscribedActivitiesResult.sort();
    }
  }

  @override
  void onMemberNotificationReceived(Member member) {
    super.onMemberNotificationReceived(member);
    notifier.value = null;

  }

}