import 'package:scoped_model/scoped_model.dart';

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