import 'package:tareas/logic/operations/abstract.dart';
import 'package:tareas/network/activities.dart';

class SubscribedActivitiesOperation extends Operation {

  @override
  Future perform() async {
    ActivitiesFetcher activitiesFetcher = ActivitiesFetcher();
    var value = await activitiesFetcher.getSubscribedActivities();
    return value;
  }

}