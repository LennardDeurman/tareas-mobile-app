import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/icons.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/logic/managers/activity_detail.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/network/auth/service.dart';
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
    showSnackBar(
        scaffoldKey: scaffoldKey,
        message: FlutterI18n.translate(context, TranslationKeys.errorLoadingMessage),
        isError: true
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

  void _executeAction(Future future) {
    showProgressDialog(context: context);
    future.catchError((e) {
      _showError();
    });
    future.whenComplete(() {
      dismissProgressDialog();
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
                                        top: 6,
                                        bottom: 12
                                      ),
                                      child: () {
                                        int assignedCount = _activityDetailManager.activity.slotInfo.assignedSlots.length;
                                        int slotsCount = _activityDetailManager.activity.slotInfo.slots.length;
                                        if (state == ActivityDetailState.enrolled || state == ActivityDetailState.enrolledAndCompleted) {
                                          String names = _activityDetailManager.activity.slotInfo.slots.map((value) {
                                            var member = value.assignedTo;
                                            var isMe = member.id == AuthService().identityResult.activeMember.id;
                                            var name = member.firstName;
                                            if (isMe) {
                                              name = FlutterI18n.translate(context, TranslationKeys.myNamePlaceholder, { "user": name });
                                            }
                                            return name;
                                          }).toList().join(", ");
                                          return TextWithIcon(
                                            iconData: FontAwesomeIcons.user,
                                            text: "$names ($assignedCount / $slotsCount)"
                                          );
                                        } else {
                                          return TextWithIcon(
                                            color: Colors.red,
                                            iconData: FontAwesomeIcons.user,
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
                        )
                    ),
                  ),
                  Visibility(child: Align(
                    alignment: Alignment.bottomCenter,
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
                  ), visible: shouldShowBar)
                ],
              );
            },
          );
        },
      )
    );
  }

}