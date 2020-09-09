import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tareas/logic/managers/open_activities.dart';
import 'package:tareas/logic/providers/open_activities.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/ui/cells/activity.dart';
import 'package:tareas/ui/extensions/backgrounds.dart';

class OpenActivitiesList extends StatefulWidget {

  final OpenActivitiesManager manager;

  OpenActivitiesList (this.manager);

  @override
  State<StatefulWidget> createState() {
    return OpenActivitiesListState();
  }
  
}

class OpenActivitiesListState extends State<OpenActivitiesList> {
  
  final BackgroundsBuilder backgroundsBuilder = BackgroundsBuilder();

  final ItemScrollController itemScrollController = ItemScrollController();

  bool isLoaded(DateTime dateTime) {
    OpenActivitiesResult openActivitiesResult = widget.manager.openActivitiesDownloader.notifier.value;
    if (openActivitiesResult != null) {
      if (openActivitiesResult.lastBlockDate != null) {
        return openActivitiesResult.lastBlockDate.millisecondsSinceEpoch > dateTime.millisecondsSinceEpoch; //last block date must be greater then retrieved date time
      }
    }
    return false;
  }

  void scrollToBottom() {
    OpenActivitiesResult openActivitiesResult = widget.manager.openActivitiesDownloader.notifier.value;
    List<Activity> activities = openActivitiesResult.items;
    itemScrollController.scrollTo(
      index: activities.length,
      duration: Duration(
        milliseconds: 200
      )
    );
  }

  void scrollToNearest(DateTime dateTime) {
    OpenActivitiesResult openActivitiesResult = widget.manager.openActivitiesDownloader.notifier.value;
    List<Activity> activities = openActivitiesResult.items;
    List<int> sameDayActivityIndices = [];
    int closestActivityIndex;
    for (int i = 0; i < activities.length; i++) {
      Activity activity = activities[i];
      int difference = activity.time.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;
      if (difference > 0 && difference < 86400 * 1000) { //isSameDay
        sameDayActivityIndices.add(i);
      } else {
        if (closestActivityIndex != null) {
          Activity closestActivity = activities[closestActivityIndex];
          int timeDifferenceFromClosestActivity = closestActivity.time.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;
          if (difference < timeDifferenceFromClosestActivity) {
            closestActivityIndex = i;
          }
        } else {
          closestActivityIndex = i;
        }
      }
    }

    int indexToScroll = closestActivityIndex;
    if (sameDayActivityIndices.length > 0) {
      indexToScroll = sameDayActivityIndices.first;
    }

    if (indexToScroll != null)
      itemScrollController.scrollTo(index: indexToScroll, duration: Duration(milliseconds: 200));

  }

  
  Widget buildBackground(BuildContext context) {
    OpenActivitiesResult openActivitiesResult = widget.manager.openActivitiesDownloader.notifier.value;
    bool isLoading = widget.manager.openActivitiesDownloader.loadingDelegate.isLoading;
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
    OpenActivitiesResult openActivitiesResult = widget.manager.openActivitiesDownloader.notifier.value;
    if (openActivitiesResult != null) {
      if (openActivitiesResult.items.length > 0) {
        return ScrollablePositionedList.builder(
            itemCount: openActivitiesResult.items.length,
            itemScrollController: this.itemScrollController,
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
          widget.manager.refreshCalendar();
          return await widget.manager.refreshOpenActivities(); //But wait for the new results to complete
        },
        child: ValueListenableBuilder<bool>(
            valueListenable: widget.manager.openActivitiesDownloader.loadingDelegate.notifier,
            builder: (BuildContext context, value, Widget widget) {
              return ValueListenableBuilder<OpenActivitiesResult>(
                  valueListenable: this.widget.manager.openActivitiesDownloader.notifier,
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