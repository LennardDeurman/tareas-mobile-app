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

class SelectionDelegate<T> extends Model {

  List<T> selectedObjects = [];

  SelectionDelegate({ List<T> selectedObjects }) {
    if (selectedObjects != null) {
      this.selectedObjects = selectedObjects;
    }
  }

  bool isSelected(T object) {
    return selectedObjects.contains(object);
  }

  void toggle(T object) {
    if (isSelected(object)) {
      selectedObjects.remove(object);
    } else {
      selectedObjects.add(object);
    }
    notifyListeners();
  }

}