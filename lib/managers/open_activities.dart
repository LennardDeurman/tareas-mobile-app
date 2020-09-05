import 'package:flutter/foundation.dart' hide Category;
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/calendar.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/activities.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/network/calendar.dart';
import 'dart:async';

enum OperationState {
  idle,
  running,
  completed
}

class CompletionResult<T> {

  final dynamic error;
  final T result;

  CompletionResult ( { this.error, this.result });

}

class WorkCompleter<T> {

  Completer _innerCompleter = Completer();

  CompletionResult _completionResult;

  void complete(T result) {
    _completionResult = CompletionResult(
      result: result
    );
    _innerCompleter.complete(result);
  }

  void completeError(e) {
    _completionResult = CompletionResult(
      error: e
    );
    _innerCompleter.completeError(e);
  }

  Future get future {
    return _innerCompleter.future;
  }

  CompletionResult get completionResult {
    return _completionResult;
  }
}

abstract class Operation<T> {

  bool isCanceled = false;

  Completer _innerCompleter;

  Function onCancel;

  WorkCompleter workCompleter = WorkCompleter(); //Used outside the operation for the total work, including then action

  Operation ();

  Future execute() async {
    _innerCompleter = Completer();
    try {
      var result = await perform();
      if (!isCanceled) {
        _innerCompleter.complete(result);
      }
    } catch (e) {
      _innerCompleter.completeError(e);
    }

  }

  Future<T> perform();

  void cancel() {
    this.isCanceled = true;
    if (onCancel != null) {
      this.onCancel();
    }
  }

  OperationState get state {
    if (_innerCompleter == null) {
      return OperationState.idle;
    } else if (_innerCompleter.isCompleted) {
      return OperationState.completed;
    } else {
      return OperationState.running;
    }
  }

}

class CalendarOverviewOperation extends Operation {

  final DateTime startDate;
  final DateTime endDate;
  final List<Category> categories;
  final bool certifiedOnly;

  CalendarOverviewOperation ({ this.startDate, this.endDate, this.categories, this.certifiedOnly = true });

  @override
  Future perform() async {
    CalendarOverviewFetcher calendarOverviewFetcher = CalendarOverviewFetcher();
    CalendarOverviewResult value = await calendarOverviewFetcher.getResult(
        certifiedOnly: this.certifiedOnly,
        certifiedUserId: AuthService().identityResult.userInfo.memberId,
        categories: categories,
        startDate: this.startDate,
        endDate: this.endDate
    );
    return value;
  }

}

class CalendarOverviewDataSource {

  final ValueNotifier<CalendarOverviewResult> notifier = ValueNotifier(null);

  DateTime _startDate;
  DateTime _endDate;
  CalendarOverviewOperation _runningOperation;

  List<Category> categories = [];


  CalendarOverviewDataSource () {
    this._startDate = DateTime.now();
    this._endDate = this._startDate.add(Duration(days: 365));
  }


  bool hasEvent(DateTime dateTime) {
    var result = notifier.value;
    if (result != null) {
        return result.eventCount(dateTime) > 0;
    }

    return false;
  }

  Future load() async {
    _runningOperation = CalendarOverviewOperation(
      startDate: this._startDate,
      endDate: this._endDate,
      certifiedOnly: true,
      categories: categories
    );
    return _runningOperation.execute().then((value) {
      notifier.value = value;
    });
  }

  void unloadExisting() {
    if (_runningOperation != null)
      _runningOperation.cancel();
    notifier.value = null;
  }

}

class OpenActivitiesOperation extends Operation {

  final DateTime startDate;
  final DateTime endDate;
  final List<Category> categories;
  final bool certifiedOnly;

  OpenActivitiesOperation ({ this.startDate, this.endDate, this.categories, this.certifiedOnly = true });

  @override
  Future perform() async {
    ActivitiesFetcher activitiesFetcher = ActivitiesFetcher();
    var value = await activitiesFetcher.getOpenActivities(
      certifiedOnly: this.certifiedOnly,
      certifiedUserId: AuthService().identityResult.userInfo.memberId,
      categories: categories,
      startDate: this.startDate,
      endDate: this.endDate
    );
    return value;
  }

}

class DatePair {

  final DateTime startDate;
  DateTime endDate;

  DatePair (this.startDate, { Duration duration }) {
    if (duration == null) {
      duration = Duration(days: 30);
    }
    this.endDate = this.startDate.add(duration);
  }

}

class DatePairGenerator {

  final DateTime startDate;

  final List<DatePair> datePairs = [];

  Duration durationBetweenPairs;

  DatePairGenerator (this.startDate, { this.durationBetweenPairs });

  DatePair next({ DateTime targetedDate }) {
    if (targetedDate != null) {
      if (targetedDate.millisecondsSinceEpoch < startDate.millisecondsSinceEpoch) {
        return null;
      } else {
        bool alreadyExists = datePairs.where((datePair) {
          return (targetedDate.millisecondsSinceEpoch >= datePair.startDate.millisecondsSinceEpoch
              && targetedDate.millisecondsSinceEpoch <= datePair.endDate.millisecondsSinceEpoch);
        }).toList().length > 0;
        if (alreadyExists)
          return null;
      }
    }
    DateTime start = startDate;
    if (datePairs.length > 0) {
      start = datePairs.last.endDate;
    }
    DatePair datePair = DatePair(start, duration: durationBetweenPairs);
    datePairs.add(datePair);
    return datePair;
  }

}

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
    });

    return OpenActivitiesResult(
        completionResults
    );

  }


}

class OpenActivitiesGlobalSyncOperation extends Operation {

  final DateTime dateTime;
  final OpenActivitiesProvider openActivitiesProvider;
  final List<Category> categories;

  OpenActivitiesGlobalSyncOperation(this.dateTime, this.openActivitiesProvider, this.categories) {
    openActivitiesProvider.categories = categories;
  }

  @override
  Future perform() {
    return this.openActivitiesProvider.loadUntil(
      dateTime
    );
  }

}


class OpenActivitiesDownloader {

  final OpenActivitiesProvider openActivitiesProvider = OpenActivitiesProvider();

  OpenActivitiesGlobalSyncOperation _openActivitiesGlobalSyncOperation;

  List<Category> categories = [];

  ValueNotifier<OpenActivitiesResult> notifier = ValueNotifier<OpenActivitiesResult>(null);

  LoadingDelegate loadingDelegate = LoadingDelegate();

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
  final CalendarOverviewDataSource  calendarOverviewDataSource = CalendarOverviewDataSource();
  final OpenActivitiesDownloader openActivitiesDownloader = OpenActivitiesDownloader();

  Future initialize() async {
    await calendarOverviewDataSource.load();
    await openActivitiesDownloader.load();
  }

  Future lookUpByDate(DateTime dateTime) async {
    await openActivitiesDownloader.load(dateTime: dateTime);
  }

  Future updateCategories(List<Category> categories) async {
    categoriesSelectionDelegate.selectedObjects = categories;
    calendarOverviewDataSource.categories = categories;
    openActivitiesDownloader.categories = categories;

    calendarOverviewDataSource.unloadExisting();
    await calendarOverviewDataSource.load();

    openActivitiesDownloader.unloadExisting();
    await openActivitiesDownloader.load();
  }
}