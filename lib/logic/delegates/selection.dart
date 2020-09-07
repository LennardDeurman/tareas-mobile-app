import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';

class SingleSelectionDelegate<T> {

  ValueNotifier<T> notifier;

  SingleSelectionDelegate ([T initialValue]) {
    notifier = ValueNotifier<T>(initialValue);
  }

  set selectedObject(T object) {
    notifier.value = object;
  }

  T get selectedObject {
    return notifier.value;
  }

}

class SelectionDelegate<T>  {


  ValueNotifier<List<T>> notifier;

  List<T> get selectedObjects {
    return notifier.value;
  }

  set selectedObjects (List<T> values) {
    this.notifier.value = values;
  }

  SelectionDelegate({ List<T> selectedObjects }) {
    notifier = ValueNotifier<List<T>>(
      selectedObjects ?? []
    );
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

    notifier.value = List.from(notifier.value);
  }

}