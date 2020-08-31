import 'package:tareas/models/activity.dart';
import 'package:tareas/network/abstract.dart';
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

  Future<List<Activity>> getOpenActivities({ DateTime startDate, DateTime endDate, bool certifiedOnly, String category, String certifiedUserId }) async {
    return await this.requestHelper.getAll(url("openActivities", queryParams: {
      NetworkParams.startDate: NetworkParams.dateString(startDate),
      NetworkParams.endDate: NetworkParams.dateString(endDate),
      NetworkParams.certifiedOnly: certifiedOnly,
      NetworkParams.category: category,
      NetworkParams.certifiedUserId: certifiedUserId
    }));
  }

  Future<List<Activity>> getSubscribedActivities() async {
    return await this.requestHelper.getAll(url("subscribedActivities"));
  }

}