import 'package:tareas/logic/operations/abstract.dart';
import 'package:tareas/logic/providers/open_activities.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/network/activities.dart';

class OpenActivitiesOperation extends Operation {

  final DateTime startDate;
  final DateTime endDate;
  final List<Category> categories;
  final bool certifiedOnly;

  OpenActivitiesOperation ({ this.startDate, this.endDate, this.categories, this.certifiedOnly = true });

  @override
  Future perform() async {
    ActivitiesFetcher activitiesFetcher = ActivitiesFetcher();
    var value = await activitiesFetcher.getOpenActivities(
        certifiedOnly: this.certifiedOnly,
        certifiedUserId: AuthService().identityResult.userInfo.memberId,
        categories: categories,
        startDate: this.startDate,
        endDate: this.endDate
    );
    return value;
  }

}

class OpenActivitiesGlobalSyncOperation extends Operation {

  final DateTime dateTime;
  final OpenActivitiesProvider openActivitiesProvider;
  final List<Category> categories;

  OpenActivitiesGlobalSyncOperation(this.dateTime, this.openActivitiesProvider, this.categories) {
    openActivitiesProvider.categories = categories;
  }

  @override
  Future perform() {
    return this.openActivitiesProvider.loadUntil(
        dateTime
    );
  }

}
