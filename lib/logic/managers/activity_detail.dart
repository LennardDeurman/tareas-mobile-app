import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tareas/logic/delegates/loading.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/models/slot.dart';
import 'package:tareas/network/activities.dart';
import 'package:tareas/network/auth/service.dart';

enum ActivityDetailState {
  full,
  openForEnrollment,
  enrolled,
  enrolledAndCompleted
}

class ActivityDetailManager {

  final Activity activity;

  final ActivitiesFetcher activitiesFetcher = ActivitiesFetcher();

  final LoadingDelegate loadingDelegate = LoadingDelegate();

  Slot _assignedToActiveMemberSlot;

  ValueNotifier<ActivityDetailState> _stateNotifier;

  ValueNotifier<ActivityDetailState> get stateNotifier {
    return _stateNotifier;
  }

  ActivityDetailManager (this.activity) {
    _assignedToActiveMemberSlot = activity.slotInfo.findSlot(
        AuthService().identityResult.activeMember.id
    );
    _stateNotifier = ValueNotifier(determineState());
  }

  ActivityDetailState determineState() {
    if (_assignedToActiveMemberSlot != null) {
      if (_assignedToActiveMemberSlot.isCompleted) {
        return ActivityDetailState.enrolledAndCompleted;
      } else {
        return ActivityDetailState.enrolled;
      }
    } else {
      if (activity.slotInfo.nextOpenSlot() != null) {
        return ActivityDetailState.openForEnrollment;
      } else {
        return ActivityDetailState.full;
      }
    }
  }

  void _refreshState() {
    _assignedToActiveMemberSlot = activity.slotInfo.findSlot(
        AuthService().identityResult.activeMember.id
    );
    _stateNotifier.value = determineState();
  }

  Future<Activity> unAssign() {
    Completer<Activity> completer = Completer();
    if (_assignedToActiveMemberSlot != null) {
      activity.slotInfo.unAssign(_assignedToActiveMemberSlot);
      _refreshState();
      activitiesFetcher.unAssignSlot(
          activity.id,
          _assignedToActiveMemberSlot.id
      ).then((value) {
        activity.parse(value.toMap());
        completer.complete(value);
      }).catchError((e) {
        activity.slotInfo.assign(_assignedToActiveMemberSlot, AuthService().identityResult.activeMember);
        completer.completeError(e);
      }).whenComplete(() {
        _refreshState();
      });
    }
    return completer.future;
  }

  Future<Activity> assign() {
    Completer<Activity> completer = Completer();
    Slot slot = activity.slotInfo.nextOpenSlot();
    if (slot != null) {
      activity.slotInfo.assign(slot, AuthService().identityResult.activeMember);
      _refreshState();
      activitiesFetcher.assignSlot(
          activity.id,
          slot.id
      ).then((value) {
        activity.parse(value.toMap());
        completer.complete(value);
      }).catchError((e) {
        activity.slotInfo.unAssign(slot);
        completer.completeError(e);
      }).whenComplete(() {
        _refreshState();
      });
    }
    return completer.future;
  }

  Future<Activity> complete() {
    Completer<Activity> completer = Completer();
    if (_assignedToActiveMemberSlot != null) {
      activity.slotInfo.complete(_assignedToActiveMemberSlot);
      _refreshState();
      activitiesFetcher.completeSlot(
          activity.id,
          _assignedToActiveMemberSlot.id
      ).then((value) {
        activity.parse(value.toMap());
        completer.complete(value);
      }).catchError((e) {
        activity.slotInfo.undoCompleted(_assignedToActiveMemberSlot);
        completer.completeError(e);
      }).whenComplete(() {
        _refreshState();
      });
    }
    return completer.future;
  }

}