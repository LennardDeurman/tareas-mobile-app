import 'package:flutter/material.dart';
import 'package:tareas/logic/managers/open_activities.dart';
import 'package:tareas/logic/providers/open_activities.dart';
import 'package:tareas/ui/cells/activity.dart';
import 'package:tareas/ui/extensions/backgrounds.dart';
class OpenActivitiesList extends StatelessWidget {

  final OpenActivitiesManager manager;

  final BackgroundsBuilder backgroundsBuilder = BackgroundsBuilder();

  OpenActivitiesList (this.manager);

  Widget buildBackground(BuildContext context) {
    OpenActivitiesResult openActivitiesResult = manager.openActivitiesDownloader.notifier.value;
    bool isLoading = manager.openActivitiesDownloader.loadingDelegate.isLoading;
    if (openActivitiesResult != null) {
      if (openActivitiesResult.items.length == 0) {
        if (isLoading) {
          return backgroundsBuilder.loadingBackground(context);
        } else if (openActivitiesResult.allSuccess) {
          return backgroundsBuilder.noResultsBackground(context);
        } else if (openActivitiesResult.allFailed) {
          return backgroundsBuilder.errorBackground(context);
        }
      }
    } else {
      if (isLoading) {
        return backgroundsBuilder.loadingBackground(context);
      } else {
        return backgroundsBuilder.noResultsBackground(context);
      }
    }
    return Container();
  }

  Widget buildList() {
    OpenActivitiesResult openActivitiesResult = manager.openActivitiesDownloader.notifier.value;
    if (openActivitiesResult != null) {
      if (openActivitiesResult.items.length > 0) {
        return ListView.builder(
          itemCount: openActivitiesResult.items.length,
          itemBuilder: (BuildContext context, int position) {
            return ActivityCell(
              openActivitiesResult.items[position]
            );
          }
        );
      }
    }
    return ListView();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        manager.refreshCalendar();
        return await manager.refreshOpenActivities(); //But wait for the new results to complete
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: manager.openActivitiesDownloader.loadingDelegate.notifier,
        builder: (BuildContext context, value, Widget widget) {
          return ValueListenableBuilder<OpenActivitiesResult>(
            valueListenable: manager.openActivitiesDownloader.notifier,
            builder: (BuildContext context, OpenActivitiesResult result, Widget widget) {
              return Stack(
                children: <Widget>[
                  buildBackground(context),
                  buildList()
                ],
              );
            }
          );
        }
      )
    );
  }

}