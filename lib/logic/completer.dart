import 'dart:async';

class CompletionResult<T> {

  final dynamic error;
  final T result;

  CompletionResult ( { this.error, this.result });

}

class WorkCompleter<T> {

  Completer _innerCompleter = Completer();

  CompletionResult<T> _completionResult;

  void complete(T result) {
    _completionResult = CompletionResult<T>(
        result: result
    );
    _innerCompleter.complete(result);
  }

  void completeError(e) {
    _completionResult = CompletionResult<T>(
        error: e
    );
    _innerCompleter.completeError(e);
  }

  Future get future {
    return _innerCompleter.future;
  }

  CompletionResult<T> get completionResult {
    return _completionResult;
  }
}
