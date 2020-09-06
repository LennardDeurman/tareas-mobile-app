import 'package:flutter/material.dart';
import 'package:tareas/logic/managers/open_activities.dart';
import 'package:tareas/logic/providers/open_activities.dart';
import 'package:tareas/ui/cells/activity.dart';
class OpenActivitiesList extends StatelessWidget {

  final OpenActivitiesManager manager;

  OpenActivitiesList (this.manager);

  Widget loadingBackground() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget noResultsBackground() {
    return Container(
      child: Center(
        child: Text("No result"),
      ),
    );
  }

  Widget errorBackground() {
    return Container(
      child: Center(
        child: Text("Error occured"),
      ),
    );
  }

  Widget buildBackground() {
    OpenActivitiesResult openActivitiesResult = manager.openActivitiesDownloader.notifier.value;
    bool isLoading = manager.openActivitiesDownloader.loadingDelegate.isLoading;
    if (openActivitiesResult != null) {
      if (openActivitiesResult.items.length == 0) {
        if (openActivitiesResult.allSuccess) {
          return noResultsBackground();
        } else if (openActivitiesResult.allFailed) {
          return errorBackground();
        }
      }
    } else {
      if (isLoading) {
        return loadingBackground();
      } else {
        return noResultsBackground();
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
        valueListenable: manager.openActivitiesDownloader.loadingDelegate.valueNotifier,
        builder: (BuildContext context, value, Widget widget) {
          return ValueListenableBuilder<OpenActivitiesResult>(
            valueListenable: manager.openActivitiesDownloader.notifier,
            builder: (BuildContext context, OpenActivitiesResult result, Widget widget) {
              return Stack(
                children: <Widget>[
                  buildBackground(),
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