import 'dart:async';

class CompletionResult<T> {

  bool isSuccess;
  dynamic error;
  T object;

  CompletionResult ( { this.error, this.isSuccess = true, this.object });

}

class OperationCompleter<T> {

  Completer _completer = Completer();
  CompletionResult<T> _completionResult;

  bool get isCompleted {
    return _completer.isCompleted;
  }

  Future get future {
    return _completer.future;
  }

  CompletionResult<T> get completionResult {
    return _completionResult;
  }

  void complete([T value]) {
    _completer.complete(value);
    _completionResult = CompletionResult<T>(object: value);
  }

  void completeError(e) {
    _completer.completeError(e);
    _completionResult = CompletionResult<T>(isSuccess: false, error: e);
  }

}

abstract class Operation<T> {

  OperationCompleter<T> currentOperation;

  bool get operationInProgress {
    if (currentOperation != null)
      return !currentOperation.isCompleted;
    return false;
  }

  OperationCompleter<T> executeOperation(); //In this method the actual downloadOperation is written

  Future execute() { //If an operation isalready in progress then return the future of that operation
    if (currentOperation != null) {
      if (!currentOperation.isCompleted) {
        return currentOperation.future;
      }
    }

    currentOperation = executeOperation();
    return currentOperation.future;
  }

}