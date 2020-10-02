import 'package:tareas/models/activity.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/models/team.dart';
import 'package:tareas/network/abstract.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/network/params.dart';

class ActivitiesFetcher extends RestFetcher<Activity> {

  @override
  RequestHelper<Activity> createRequestHelper() {
    return RequestHelper<Activity>(toObject: (Map map) {
      return Activity(map);
    });
  }

  @override
  Future<Activity> post(Activity object) {
    throw UnimplementedError();
  }

  @override
  Future<Activity> put(Activity object) {
    throw UnimplementedError();
  }

  @override
  Future<Activity> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Activity> get(String id) async {
    return await this.requestHelper.getSingle(url("activities/$id"));
  }

  @override
  Future<List<Activity>> getAll() async {
    return await this.requestHelper.getAll(url("activities"));
  }

  Future<List<Activity>> getOpenActivities({ DateTime startDate, DateTime endDate, bool certifiedOnly, List<Category> categories, List<Team> teams, String certifiedUserId }) async {
    return await this.requestHelper.getAll(url("openActivities", queryParams: {
      NetworkParams.startDate: NetworkParams.dateString(startDate),
      NetworkParams.endDate: NetworkParams.dateString(endDate),
      NetworkParams.certifiedOnly: certifiedOnly.toString(),
      NetworkParams.categories: NetworkParams.namedIdList(categories),
      NetworkParams.teams: NetworkParams.namedIdList(teams), 
      NetworkParams.certifiedUserId: certifiedUserId,
      NetworkParams.includeTeamlessActivities: true.toString()
    }));
  }

  Future<List<Activity>> getSubscribedActivities() async {
    String memberId = AuthService().identityResult.activeMember.id;
    return await this.requestHelper.getAll(url("subscribedActivities/$memberId"));
  }

  Future<Activity> assignSlot(String activityId, String slotId) async {
    String memberId = AuthService().identityResult.activeMember.id;
    return await this.requestHelper.post(url("activities/$activityId/slots/$slotId/assign"), body: memberId);
  }

  Future<Activity> unAssignSlot(String activityId, String slotId) async {
    return await this.requestHelper.delete(url("activities/$activityId/slots/$slotId/assign"));
  }

  Future<Activity> completeSlot(String activityId, String slotId) async {
    return await this.requestHelper.post(url("activities/$activityId/slots/$slotId/complete"));
  }



}