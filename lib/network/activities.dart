import 'package:tareas/models/activity.dart';
import 'package:tareas/network/abstract.dart';

class ActivitiesFetcher extends RestFetcher<Activity> {

  @override
  RequestHelper<Activity> createRequestHelper() {
    return RequestHelper<Activity>(toObject: (Map map) => Activity(map) );
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
  Future<Activity> get(String id) {
    return this.requestHelper.getSingle(url("activities/$id"));
  }

  @override
  Future<List<Activity>> getAll() {
    return this.requestHelper.getAll(url("activities"));
  }

  Future<List<Activity>> getOpenActivities() {
    return this.requestHelper.getAll(url("openActivities"));
  }

  Future<List<Activity>> getSubscribedActivities() {
    return this.requestHelper.getAll(url("subscribedActivities"));
  }

}