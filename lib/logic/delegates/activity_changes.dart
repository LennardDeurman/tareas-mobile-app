import 'package:flutter/foundation.dart';
import 'package:tareas/models/activity.dart';

typedef ActivityChangeCallback = void Function(Activity);

class ActivityChangesHandler {

  ActivityChangeCallback onUpdate;

  ActivityChangesHandler ({ this.onUpdate });

}


class ActivityChangesDelegate {


  static final ActivityChangesDelegate _instance = ActivityChangesDelegate._internal();

  factory ActivityChangesDelegate() {
    return _instance;
  }

  ActivityChangesDelegate._internal();

  List<ActivityChangesHandler> _activityChangesHandlers = [];

  void register({ @required ActivityChangesHandler handler }) {
    _activityChangesHandlers.add(handler);
  }

  void unRegister({ @required ActivityChangesHandler handler }) {
    _activityChangesHandlers.remove(handler);
  }

  void onUpdate(Activity activity) {
    _activityChangesHandlers.forEach((handler) => handler.onUpdate(activity));
  }

}