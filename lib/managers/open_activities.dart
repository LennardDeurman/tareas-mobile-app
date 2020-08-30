import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/models/category.dart';

abstract class SyncOperation {

  Completer currentOperation;

  bool get operationInProgress {
    if (currentOperation != null)
      return !currentOperation.isCompleted;
    return false;
  }

  Completer downloadOperation(); //In this method the actual downloadOperation is written

  Future download() { //If an operation isalready in progress then return the future of that operation
    if (currentOperation != null) {
      if (!currentOperation.isCompleted) {
        return currentOperation.future;
      }
    }
    currentOperation = downloadOperation();
    return currentOperation.future;
  }

}


class OpenActivitiesManager extends Model {

  final SelectionDelegate<Category> categoriesSelectionDelegate = SelectionDelegate<Category>();

}