import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/member.dart';

class SlotKeys {
  static const String activityId = "activityId";
  static const String assignedTo = "assignedTo";
  static const String isAssigned = "isAssigned";
  static const String isCompleted = "isCompleted";

}


class Slot extends BaseObject {

  int activityId;
  bool isAssigned;
  bool isCompleted;
  Member assignedTo;


  Slot (Map map) : super(map);

  @override
  Map toMap() {
    return {
      BaseObjectKeys.id: id,
      SlotKeys.activityId: activityId,
      SlotKeys.isAssigned: isAssigned,
      SlotKeys.isCompleted: isCompleted,
      SlotKeys.assignedTo: objectMap(assignedTo)
    };
  }

  @override
  void parse(Map json) {
    id = json[BaseObjectKeys.id];
    activityId = json[SlotKeys.activityId];
    isAssigned = json[SlotKeys.isAssigned];
    isCompleted = json[SlotKeys.isCompleted];
    assignedTo = parseObject(json[SlotKeys.assignedTo], toObject: (Map map) {
      return Member(map);
    });
  }

}