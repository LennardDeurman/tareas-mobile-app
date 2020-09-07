import 'package:flutter/material.dart';
import 'package:tareas/logic/managers/subscribed_activities.dart';
import 'package:tareas/ui/extensions/backgrounds.dart';
import 'package:tareas/ui/lists/base/tableview.dart';

class SubscribedActivitiesList extends StatelessWidget {

  final SubscribedActivitiesManager manager;

  final BackgroundsBuilder backgroundsBuilder = BackgroundsBuilder();

  SubscribedActivitiesList (this.manager);

  Widget buildBackground() {
    SubscribedActivitiesResult subscribedActivitiesResult = manager.notifier.value;
    bool isLoading = manager.loadingDelegate.isLoading;
    if (subscribedActivitiesResult != null) {
      if (isLoading) {
        return backgroundsBuilder.loadingBackground();
      } else if (subscribedActivitiesResult.completionResult.error != null) {
        return backgroundsBuilder.errorBackground();
      } else if (subscribedActivitiesResult.completionResult.result != null) {
        if (subscribedActivitiesResult.completionResult.result.length == 0) {
          return backgroundsBuilder.noResultsBackground();
        }
      }
    } else {
      if (isLoading) {
        return backgroundsBuilder.loadingBackground();
      } else {
        return backgroundsBuilder.noResultsBackground();
      }
    }
    return Container();
  }

  Widget buildList() {
    SubscribedActivitiesResult subscribedActivitiesResult = manager.notifier.value;
    if (subscribedActivitiesResult != null) {
      return TableView(
          TableViewBuilder(
              sectionHeaderBuilder: (int section) {
                DateTime sectionDateTime = subscribedActivitiesResult.sortedResult.sectionKeys[section];
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    sectionDateTime.toString()
                  ),
                );
              },
              numberOfRows: (int section) {
                return subscribedActivitiesResult.sortedResult.numberOfRows(section);
              },
              sectionCount: subscribedActivitiesResult.sortedResult.sectionKeys.length
          )
      );
    }
    return ListView();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          return await manager.refresh(
            force: true
          );
        },
        child: ValueListenableBuilder<bool>(
            valueListenable: manager.loadingDelegate.valueNotifier,
            builder: (BuildContext context, value, Widget widget) {
              return ValueListenableBuilder<SubscribedActivitiesResult>(
                  valueListenable: manager.notifier,
                  builder: (BuildContext context, SubscribedActivitiesResult result, Widget widget) {
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