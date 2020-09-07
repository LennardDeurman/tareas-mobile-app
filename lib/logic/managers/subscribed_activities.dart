import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/logic/completer.dart';
import 'package:tareas/logic/delegates/loading.dart';
import 'package:tareas/logic/operations/subscribed_activities.dart';
import 'package:tareas/models/activity.dart';

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

class SubscribedActivitiesResult {

  final CompletionResult<List<Activity>> completionResult;

  SubscribedActivitiesSortedResult _subscribedActivitiesSortedResult;

  SubscribedActivitiesSortedResult get sortedResult {
    return _subscribedActivitiesSortedResult;
  }

  SubscribedActivitiesResult (this.completionResult) {
    List<DateTime> dates = [];
    List<List<Activity>> items = [];
    if (completionResult.result != null) {
      List<Activity> activities = completionResult.result;
      Map resultMap = Map<DateTime, List<Activity>>();
      for (Activity activity in activities) {
        DateTime dateTime = DateTime(
          activity.time.day,
          activity.time.month,
          activity.time.year
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
      items = resultMap.values.toList();

    }

    _subscribedActivitiesSortedResult = SubscribedActivitiesSortedResult(
      sectionKeys: dates,
      sectionItems: items
    );
  }



}


class SubscribedActivitiesManager extends Model {

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

}