import 'package:flutter/foundation.dart';

class LoadingDelegate  {

  final ValueNotifier<bool> notifier = ValueNotifier(false);

  set isLoading (bool value) {
    notifier.value = value;
  }

  bool get isLoading {
    return notifier.value;
  }

  void attachFuture(Future future) {
    isLoading = true;
    future.whenComplete(() => isLoading = false);
  }


}