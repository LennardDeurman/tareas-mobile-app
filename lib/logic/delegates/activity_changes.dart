import 'package:flutter/foundation.dart';
import 'package:tareas/models/activity.dart';

typedef ActivityChangeCallback = void Function(Activity);

abstract class ActivityNotificationObserver {

  ActivityNotificationObserver ();

  void onNotificationReceived(Activity activity);

}

class ActivityNotificationCenter {


  static final ActivityNotificationCenter _instance = ActivityNotificationCenter._internal();

  factory ActivityNotificationCenter() {
    return _instance;
  }

  ActivityNotificationCenter._internal();

  List<ActivityNotificationObserver> _observers = [];

  void register({ @required ActivityNotificationObserver observer }) {
    _observers.add(observer);
  }

  void unRegister({ @required ActivityNotificationObserver observer }) {
    _observers.remove(observer);
  }

  void sendNotification(Activity activity) {
    _observers.forEach((observer) => observer.onNotificationReceived(activity));
  }

}