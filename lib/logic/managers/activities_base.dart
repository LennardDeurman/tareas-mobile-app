import 'package:tareas/logic/delegates/activity_changes.dart';

abstract class ActivitiesManager implements ActivityNotificationObserver {

  ActivitiesManager () {
    ActivityNotificationCenter().register(
        observer: this
    );
  }

  void dispose() {
    ActivityNotificationCenter().unRegister(
        observer: this
    );
  }

}