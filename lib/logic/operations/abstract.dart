import 'dart:async';
import 'package:tareas/logic/completer.dart';

enum OperationState {
  idle,
  running,
  completed
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
    return _innerCompleter.future;
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