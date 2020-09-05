import 'dart:async';

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
