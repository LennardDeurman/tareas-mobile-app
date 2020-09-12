import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/member.dart';
import 'package:tareas/models/slot.dart';
import 'package:tareas/models/tasks/task.dart';
import 'package:tareas/models/team.dart';

class ActivityKeys with BaseObjectKeys {

  static const String id = "id";
  static const String time = "time";
  static const String description = "description";
  static const String shortDescription = "shortDescription";
  static const String isAssigned = "isAssigned";
  static const String isCompleted = "isCompleted";
  static const String isCancelled = "isCancelled";
  static const String task = "task";
  static const String slots = "slots";
  static const String slotCount = "slotCount";
  static const String assignedTeam = "assignedTeam";
  static const String isFull = "isFull";

}

class SlotInfo {

  List<Slot> slots;
  int count;

  List<Slot> _unAssignedSlots;
  List<Slot> _assignedSlots;

  List<Slot> get unAssignedSlots {
    return _unAssignedSlots;
  }

  List<Slot> get assignedSlots {
    return _assignedSlots;
  }

  SlotInfo ({ this.slots, this.count }) {
    _refresh();
  }

  void _refresh() {
    _unAssignedSlots = [];
    _assignedSlots = [];
    for (Slot slot in slots) {
      if (slot.isAssigned) {
        _assignedSlots.add(slot);
      } else {
        _unAssignedSlots.add(slot);
      }
    }
  }

  Slot nextOpenSlot() {
    return _unAssignedSlots.length > 0 ? _unAssignedSlots.first : null;
  }

  Slot findSlot(String memberId) {
    return _assignedSlots.firstWhere((slot) {
      if (slot.assignedTo != null) {
        return slot.assignedTo.id == memberId;
      }
      return false;
    }, orElse: () {
      return null;
    });
  }

  void assign(Slot slot, Member member) {
    slot.isAssigned = true;
    slot.assignedTo = member;
    _refresh();
  }

  void unAssign(Slot slot) {
    slot.isAssigned = false;
    slot.assignedTo = null;
    _refresh();
  }

  void complete(Slot slot) {
    slot.isCompleted = true;
  }

  void undoCompleted(Slot slot) {
    slot.isCompleted = false;
  }


}

class Activity extends BaseObject {

  DateTime time;
  bool isAssigned;
  bool isCompleted;
  bool isCancelled;
  bool isFull;
  Task task;
  Team assignedTeam;
  SlotInfo slotInfo;

  String _description;
  String _shortDescription;

  Activity (Map json) : super(json);

  String get name {
    return task.name;
  }

  String get shortDescription {
    if (_shortDescription != null) {
      return _shortDescription;
    }
    return task.shortDescription;
  }

  String get description {
    if (_description != null) {
      return _description;
    }
    return task.description;
  }

  bool get isSoon {
    var difference = time.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    int daysMargin = 5;
    return difference > 0 && difference < 86400 * 1000 * daysMargin;
  }

  @override
  void parse(Map json) {
    super.parse(json);

    time = dateFromJson(json[ActivityKeys.time]);
    isAssigned = json[ActivityKeys.isAssigned];
    isCompleted = json[ActivityKeys.isCompleted];
    isCancelled = json[ActivityKeys.isCancelled];
    isFull = json[ActivityKeys.isFull];



    _description = json[ActivityKeys.description];
    _shortDescription = json[ActivityKeys.shortDescription];

    assignedTeam = parseObject(json[ActivityKeys.assignedTeam], toObject: (Map map) {
      return Team(map);
    });

    task = parseObject(json[ActivityKeys.task], toObject: (Map map) {
      return Task(map);
    });


    slotInfo = SlotInfo(
      count: json[ActivityKeys.slotCount],
      slots: parseList(json[ActivityKeys.slots], toObject: (Map map) {
        return Slot(map);
      })
    );

  }

  @override
  Map toMap() {
    return {
      ActivityKeys.id: id,
      ActivityKeys.task: objectMap(task),
      ActivityKeys.assignedTeam: objectMap(assignedTeam),
      ActivityKeys.slotCount: slotInfo.count,
      ActivityKeys.slots: objectsMapList(slotInfo.slots),
      ActivityKeys.isFull: isFull,
      ActivityKeys.time: jsonValueOfDate(time),
      ActivityKeys.isAssigned: isAssigned,
      ActivityKeys.isCompleted: isCompleted,
      ActivityKeys.isCancelled: isCancelled,
      ActivityKeys.shortDescription: shortDescription,
      ActivityKeys.description: description
    };
  }
}