import 'package:tareas/models/activity.dart';

abstract class ActivitiesResult {

  Activity findById(String id);

  void sort();

  void insert(Activity activity);

  bool filter(Activity activity);

}