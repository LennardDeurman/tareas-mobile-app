import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/logic/delegates/activity_changes.dart';
import 'package:tareas/logic/delegates/loading.dart';
import 'package:tareas/logic/managers/open_activities.dart';
import 'package:tareas/logic/providers/open_activities.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/ui/cells/activity.dart';
import 'package:tareas/ui/extensions/backgrounds.dart';

class OpenActivitiesList extends StatefulWidget {

  final OpenActivitiesManager manager;

  OpenActivitiesList (this.manager, { GlobalKey<OpenActivitiesListState> key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OpenActivitiesListState();
  }
  
}

class OpenActivitiesListState extends State<OpenActivitiesList> {
  
  final BackgroundsBuilder backgroundsBuilder = BackgroundsBuilder();
  final LoadingDelegate appendingItemsLoadingDelegate = LoadingDelegate();

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

  void scrollToIndex(int index, { bool withAnimation }) {
    if (withAnimation) {
      itemScrollController.scrollTo(
          index: index,
          duration: Duration(
              milliseconds: 200
          )
      );
    } else {
      itemScrollController.jumpTo(
          index: index
      );
    }
  }

  void scrollToBottom({ bool withAnimation = true }) {
    OpenActivitiesResult openActivitiesResult = widget.manager.openActivitiesDownloader.notifier.value;
    List<Activity> activities = openActivitiesResult.items;
    if (activities.length > 0) {
      scrollToIndex(
        activities.length - 1,
        withAnimation: withAnimation
      );
    }



  }

  void scrollToNearest(DateTime dateTime, { bool withAnimation = true }) {
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
          timeDifferenceFromClosestActivity = timeDifferenceFromClosestActivity.abs();
          difference = difference.abs();
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

    if (indexToScroll != null) {
      scrollToIndex(
          indexToScroll,
          withAnimation: withAnimation
      );
    }


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
            itemCount: openActivitiesResult.items.length + 1,
            itemScrollController: this.itemScrollController,
            itemBuilder: (BuildContext context, int position) {
              if (position < openActivitiesResult.items.length) {
                return ActivityCell(
                    openActivitiesResult.items[position]
                );
              } else {
                return ValueListenableBuilder(
                  valueListenable: this.appendingItemsLoadingDelegate.notifier,
                  builder: (BuildContext context, bool isLoading, Widget widget) {
                    return Visibility(
                      visible: appendingItemsLoadingDelegate.isLoading,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                            SizedBox(width: 25),
                            Container(
                              child: Text(
                                FlutterI18n.translate(context, TranslationKeys.loadingExtraInProgress),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(width: 25)
                          ],
                        ),
                      ),
                    );
                  }
                );
              }
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