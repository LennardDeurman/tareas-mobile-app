import 'package:flutter/foundation.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/member.dart';

typedef ActivityChangeCallback = void Function(Activity);
typedef MemberChangeCallback = void Function(Member);

abstract class ActivityNotificationObserver {

  ActivityNotificationObserver ();

  void onActivityNotificationReceived(Activity activity);

}

abstract class MemberNotificationObserver {

  MemberNotificationObserver ();

  void onMemberNotificationReceived(Member member);

}


abstract class NotificationCenter<T, Z> {

  List<T> _observers = [];

  void register({ @required T observer }) {
    _observers.add(observer);
  }

  void unRegister({ @required T observer }) {
    _observers.remove(observer);
  }

  void sendNotification(Z object);

  void sendObserverCall({ @required Function(T) call }) {
    _observers.forEach((observer) => call(observer));
  }

}

class ActivityNotificationCenter extends NotificationCenter<ActivityNotificationObserver, Activity> {


  static final ActivityNotificationCenter _instance = ActivityNotificationCenter._internal();

  factory ActivityNotificationCenter() {
    return _instance;
  }

  ActivityNotificationCenter._internal();

  @override
  void sendNotification(Activity object) {
    sendObserverCall(
      call: (observer) => observer.onActivityNotificationReceived(object)
    );
  }

}



class MemberChangeNotificationCenter extends NotificationCenter<MemberNotificationObserver, Member> {

  static final MemberChangeNotificationCenter _instance = MemberChangeNotificationCenter._internal();

  factory MemberChangeNotificationCenter() {
    return _instance;
  }

  MemberChangeNotificationCenter._internal();

  @override
  void sendNotification(Member object) {
    sendObserverCall(
        call: (observer) => observer.onMemberNotificationReceived(object)
    );
  }

}