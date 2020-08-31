import 'package:tareas/network/operations/abstract.dart';
import 'package:tareas/network/activities.dart';
import 'package:tareas/network/auth/service.dart';

class OpenActivitiesOperation extends Operation  {

  static final OpenActivitiesOperation _instance = OpenActivitiesOperation._internal();

  factory OpenActivitiesOperation() {
    return _instance;
  }

  OpenActivitiesOperation._internal();

  @override
  OperationCompleter executeOperation() {
    OperationCompleter completer = OperationCompleter();

    var activitiesFetcher = ActivitiesFetcher();
    activitiesFetcher.getOpenActivities(startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 365)), certifiedOnly: true, certifiedUserId: AuthService().identityResult.userInfo.memberId).then((activities) {
      //openActivitiesDatabase.update(activities);
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer;
  }

}

