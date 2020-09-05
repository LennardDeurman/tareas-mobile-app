import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';

class LoadingDelegate extends Model {

  final ValueNotifier valueNotifier = ValueNotifier(false);

  LoadingDelegate () {
    valueNotifier.addListener(() {
      notifyListeners();
    });
  }

  set isLoading (bool value) {
    valueNotifier.value = value;
  }

  bool get isLoading {
    return valueNotifier.value;
  }

  void attachFuture(Future future) {
    isLoading = true;
    future.whenComplete(() => isLoading = false);
  }
}