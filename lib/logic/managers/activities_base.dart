import 'package:tareas/logic/delegates/notification_center.dart';
import 'package:tareas/models/member.dart';

abstract class ActivitiesManager implements ActivityNotificationObserver, MemberNotificationObserver {

  Function onOrganisationChange;

  ActivitiesManager () {
    ActivityNotificationCenter().register(
        observer: this
    );
    MemberChangeNotificationCenter().register(
      observer: this
    );
  }

  void dispose() {
    ActivityNotificationCenter().unRegister(
        observer: this
    );
    MemberChangeNotificationCenter().unRegister(
      observer: this
    );
  }

  @override
  void onMemberNotificationReceived(Member member) {
    if (onOrganisationChange != null) {
      onOrganisationChange();
    }
  }

}