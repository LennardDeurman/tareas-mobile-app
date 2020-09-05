import 'dart:async';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/logic/completer.dart';
import 'package:tareas/logic/operations/open_activities.dart';
import 'package:tareas/logic/operations/abstract.dart';
import 'package:tareas/logic/datepair.dart';

class OpenActivitiesResult {

  final List<CompletionResult> completionResults;

  List<CompletionResult> _failedCompletionResults = [];
  List<CompletionResult> _succeedCompletionResults = [];
  List<Activity> _activityItems = [];

  OpenActivitiesResult (this.completionResults) {
    sortItems();
  }

  void sortItems() {
    for (CompletionResult completionResult in this.completionResults) {
      bool hasError = completionResult.error != null;
      if (completionResult.result != null) {
        List<Activity> items = completionResult.result;
        _activityItems.addAll(items);
      }
      if (hasError) {
        _failedCompletionResults.add(completionResult);
      } else {
        _succeedCompletionResults.add(completionResult);
      }
    }

    _activityItems.sort((Activity activity1, Activity activity2) {
      return activity1.time.compareTo(activity2.time);
    });
  }

  bool get allFailed {
    return _succeedCompletionResults.length == 0;
  }

  bool get allSuccess {
    return _failedCompletionResults.length == 0;
  }

  List<Activity> get items {
    return _activityItems;
  }
}

class OpenActivitiesProvider {


  List<OpenActivitiesOperation> _operations = [];

  List<Category> categories = [];

  Future loadUntil(DateTime dateTime) {
    OpenActivitiesOperation existingOperation;
    DateTime lastEndDate = DateTime.now();

    for (OpenActivitiesOperation operation in _operations) {

      if (lastEndDate == null) {
        lastEndDate = operation.endDate;
      } else {
        if (operation.endDate.millisecondsSinceEpoch > lastEndDate.millisecondsSinceEpoch) {
          lastEndDate = operation.endDate;
        }
      }


      if (dateTime.millisecondsSinceEpoch >= operation.startDate.millisecondsSinceEpoch &&
          dateTime.millisecondsSinceEpoch <= operation.endDate.millisecondsSinceEpoch) {
        existingOperation = operation;
      }
    }

    if (existingOperation == null) {
      DatePairGenerator generator = DatePairGenerator(lastEndDate);
      while (generator.next(targetedDate: dateTime) != null);
      for (DatePair datePair in generator.datePairs) {
        _addOperation(
            start: datePair.startDate,
            end: datePair.endDate
        );
      }
    }

    List<OpenActivitiesOperation> runningOperations = _operations.where((value) {
      return value.state == OperationState.running;
    }).toList();

    if (runningOperations.length > 0) { //Wait for when all the runningOperations complete
      List<Future> workingFutures = runningOperations.map((operation) {
        return operation.workCompleter.future;
      });

      return Future.wait(workingFutures).catchError((e) { //If one of the blocks throws an error, the whole future fails => correct, and all the operations will be removed
        runningOperations.forEach((operation) => this._operations.remove(operation));
      });
    } else {
      //There are no running operations, so complete immediatly
      Completer completer = Completer();
      completer.complete();
      return completer.future;
    }

  }

  Future _addOperation({ DateTime start, DateTime end }) async {
    OpenActivitiesOperation openActivitiesOperation = OpenActivitiesOperation(
        startDate: start,
        endDate: end,
        certifiedOnly: true,
        categories: categories
    );
    _operations.add(openActivitiesOperation);

    var future = await openActivitiesOperation.execute().then((values) {
      openActivitiesOperation.workCompleter.complete(values);
    }).catchError((e) {
      openActivitiesOperation.workCompleter.completeError(e);
    });

    return future;

  }

  void unloadAll() {
    for (Operation operation in _operations) {
      if (operation.state == OperationState.running) {
        operation.cancel();
      }
    }
    this._operations = [];
  }

  OpenActivitiesResult getResult() {

    List<CompletionResult> completionResults = _operations.map((operation) {
      return operation.workCompleter.completionResult;
    }).toList();

    return OpenActivitiesResult(
        completionResults
    );

  }


}