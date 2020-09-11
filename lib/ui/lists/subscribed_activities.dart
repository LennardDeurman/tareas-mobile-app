import 'package:flutter/material.dart';
import 'package:tareas/logic/managers/subscribed_activities.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/ui/cells/activity.dart';
import 'package:tareas/ui/extensions/backgrounds.dart';
import 'package:tareas/ui/extensions/dates.dart';
import 'package:tareas/ui/lists/base/tableview.dart';

class SubscribedActivitiesList extends StatelessWidget {

  final SubscribedActivitiesManager manager;

  final BackgroundsBuilder backgroundsBuilder = SubscribedActivitiesBackgroundsBuilder();

  SubscribedActivitiesList (this.manager);

  Widget buildBackground(BuildContext context) {
    SubscribedActivitiesResult subscribedActivitiesResult = manager.notifier.value;
    bool isLoading = manager.loadingDelegate.isLoading;
    if (subscribedActivitiesResult != null) {
      if (isLoading) {
        return backgroundsBuilder.loadingBackground(context);
      } else if (subscribedActivitiesResult.completionResult.error != null) {
        return backgroundsBuilder.errorBackground(context);
      } else if (subscribedActivitiesResult.completionResult.result != null) {
        if (subscribedActivitiesResult.completionResult.result.length == 0) {
          return backgroundsBuilder.noResultsBackground(context);
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
    SubscribedActivitiesResult subscribedActivitiesResult = manager.notifier.value;
    if (subscribedActivitiesResult != null) {
      return TableView(
          TableViewBuilder(
              itemBuilder: (BuildContext context, int row, int section) {
                Activity activity = subscribedActivitiesResult.sortedResult.sectionItems[section][row];
                return ActivityCell(
                  activity
                );
              },
              sectionFooterBuilder: (int section) {
                return SizedBox(height: 10);
              },
              sectionHeaderBuilder: (int section) {
                DateTime sectionDateTime = subscribedActivitiesResult.sortedResult.sectionKeys[section];
                return Container(
                  padding: EdgeInsets.only(
                    bottom: 12,
                    left: 20,
                    top: 12
                  ),
                  child: Text(
                    FriendlyDateFormat.format(sectionDateTime, onlyDate: true),
                    style: TextStyle(
                      fontSize: 21
                    ),
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
            valueListenable: manager.loadingDelegate.notifier,
            builder: (BuildContext context, value, Widget widget) {
              return ValueListenableBuilder<SubscribedActivitiesResult>(
                  valueListenable: manager.notifier,
                  builder: (BuildContext context, SubscribedActivitiesResult result, Widget widget) {
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