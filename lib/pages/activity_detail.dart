import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/icons.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/logic/managers/activity_detail.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/ui/extensions/buttons.dart';
import 'package:tareas/ui/extensions/dates.dart';
import 'package:tareas/ui/extensions/labels.dart';
import 'package:tareas/ui/extensions/messages.dart';



class ActivityDetailPage extends StatefulWidget {

  final Activity activity;

  ActivityDetailPage (this.activity);

  @override
  State<StatefulWidget> createState() {
    return _ActivityDetailPageState();
  }

}

class _ActivityDetailPageState extends State<ActivityDetailPage> {

  ActivityDetailManager _activityDetailManager;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _activityDetailManager = ActivityDetailManager(this.widget.activity);
    super.initState();
  }

  bool get shouldShowBar { 
    return _activityDetailManager.stateNotifier.value == ActivityDetailState.openForEnrollment
        || _activityDetailManager.stateNotifier.value == ActivityDetailState.enrolled;
  }

  void _showError() {
    showToast(
      message:  FlutterI18n.translate(context, TranslationKeys.errorLoadingMessage)
    );
  }

  void _unAssign() {
    Future future = _activityDetailManager.unAssign();
    _executeAction(future);
  }

  void _assign() {
    Future future = _activityDetailManager.assign();
    _executeAction(future);
  }

  void _complete() {
    Future<Activity> future = _activityDetailManager.complete();
    _executeAction(future);
  }

  void _addCalendarEvent() {
    Event event = Event(
      title: _activityDetailManager.activity.name,
      description: _activityDetailManager.activity.description,
      startDate: _activityDetailManager.activity.time,
      endDate: _activityDetailManager.activity.time.add(Duration(hours: 2)),
    );
    Add2Calendar.addEvent2Cal(event);
  }

  void _executeAction(Future future) {
    future.catchError((e) {
      _showError();
    });

    _activityDetailManager.loadingDelegate.attachFuture(
        future
    );
  }

  Widget _enrolledStateBar() {
    return Row(
      children: <Widget>[
        SecondaryButton(
          borderRadius: 7,
          textMargin: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 5
          ),
          iconMargin: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 3
          ),
          color: BrandColors.textLabelColor,
          borderColor: BrandColors.secondarButtonBorderColor,
          iconData: FontAwesomeIcons.undo,
          text: FlutterI18n.translate(context, TranslationKeys.setBack),
          onPressed: _unAssign,
        ),
        Spacer(),
        PrimaryButton(
          borderRadius: 7,
          textMargin: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 5
          ),
          iconMargin: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 3
          ),
          color: BrandColors.primaryColor,
          iconData: FontAwesomeIcons.thumbsUp,
          text: FlutterI18n.translate(context, TranslationKeys.completeTask),
          onPressed: _complete,
        )
      ],
    );
  }

  Widget _openStateBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: PrimaryButton(
            color: BrandColors.primaryColor,
            iconData: FontAwesomeIcons.check,
            text: FlutterI18n.translate(context, TranslationKeys.accept),
            onPressed: _assign,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.calendarPlus),
            onPressed: _addCalendarEvent,
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _activityDetailManager.loadingDelegate.notifier,
        builder: (BuildContext context, bool isLoading, Widget innerWidget) {
          return ValueListenableBuilder(
            valueListenable: _activityDetailManager.stateNotifier,
            builder: (BuildContext context, ActivityDetailState state, Widget innerWidget) {
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                        color: Colors.white,
                        child: RefreshIndicator(
                          onRefresh: () {
                            return _activityDetailManager.refreshActivity();
                          },
                          child: SingleChildScrollView(
                            padding: shouldShowBar ? EdgeInsets.only(bottom: 80) : null,
                            child: Column(
                              children: <Widget>[
                                Container(child: Stack(
                                  children: <Widget>[
                                    Container(child: Image(
                                      image: NetworkImage(
                                          "https://singularityhub.com/wp-content/uploads/2018/10/abstract-blurred-background-casino_shutterstock_1126650161.jpg" //TODO: Replace!!
                                      ),
                                      fit: BoxFit.cover,
                                    ), constraints: BoxConstraints(
                                        minHeight: 300
                                    )),
                                    Positioned.fill(
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 6
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(7)
                                                  ),
                                                  child: TextWithIcon(
                                                    iconData: FontAwesomeIcons.clock,
                                                    textMargin: EdgeInsets.symmetric(
                                                        horizontal: 5
                                                    ),
                                                    iconMargin: EdgeInsets.symmetric(
                                                        horizontal: 3
                                                    ),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: widget.activity.isSoon ? BrandColors.errorColor : Colors.black,
                                                    text: FriendlyDateFormat.format(widget.activity.time),
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                        margin: EdgeInsets.all(20),
                                      ),
                                    )
                                  ],
                                )),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: 6
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            FaIcon(
                                              TareasIcons.categoryIcons[this.widget.activity.task.category.name],
                                              color: BrandColors.iconColor,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              this.widget.activity.name,
                                              style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 8,
                                            bottom: 12
                                        ),
                                        child: () {
                                          int assignedCount = _activityDetailManager.activity.slotInfo.assignedSlots.length;
                                          int slotsCount = _activityDetailManager.activity.slotInfo.slots.length;
                                          if (state == ActivityDetailState.enrolled || state == ActivityDetailState.enrolledAndCompleted) {
                                            String names = _activityDetailManager.activity.slotInfo.assignedSlots.map((value) {
                                              var member = value.assignedTo;
                                              var name = member.firstName;
                                              return name;
                                            }).toList().join(", ");
                                            return TextWithIcon(
                                                iconData: FontAwesomeIcons.user,
                                                color: Colors.red,
                                                textMargin: EdgeInsets.only(
                                                    left: 12
                                                ),
                                                text: "$names ($assignedCount/$slotsCount)"
                                            );
                                          } else {
                                            return TextWithIcon(
                                              color: Colors.red,
                                              iconData: FontAwesomeIcons.user,
                                              textMargin: EdgeInsets.only(
                                                  left: 12
                                              ),
                                              text: FlutterI18n.translate(
                                                  context,
                                                  TranslationKeys.requiredPersons,
                                                  {
                                                    "current": assignedCount.toString(),
                                                    "max": slotsCount.toString()
                                                  }
                                              ),
                                            );
                                          }
                                        }(),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 12
                                        ),
                                        child: Text(
                                          widget.activity.shortDescription,
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 15
                                        ),
                                        child: Text(
                                          widget.activity.description,
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: state == ActivityDetailState.enrolledAndCompleted,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10
                                          ),
                                          child: TextWithIcon(
                                            iconData: Icons.check,
                                            color: Colors.green,
                                            iconSize: 30,
                                            textMargin: EdgeInsets.only(
                                                left: 12
                                            ),
                                            fontWeight: FontWeight.bold,
                                            text: FlutterI18n.translate(context, TranslationKeys.alreadyFinished),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: state == ActivityDetailState.full,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10
                                          ),
                                          child: TextWithIcon(
                                            iconData: Icons.warning,
                                            color: Colors.amber,
                                            text: FlutterI18n.translate(context, TranslationKeys.activityFull),
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      child: Container(
                          height: 80,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20
                          ),
                          child: () {
                            if (state == ActivityDetailState.openForEnrollment) {
                              return _openStateBar();
                            } else if (state == ActivityDetailState.enrolled) {
                              return _enrolledStateBar();
                            } else {
                              return Container();
                            }
                          }()
                      ),
                      visible: shouldShowBar,
                    ),
                  ),
                  Visibility(child: Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 25
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                child:  CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20
                                ),
                                child: Text(
                                  FlutterI18n.translate(context, TranslationKeys.sendingData),
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ), visible: isLoading)
                ],
              );
            },
          );
        },
      )
    );
  }

}