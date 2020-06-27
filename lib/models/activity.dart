import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/tasks/task.dart';

class ActivityKeys with BaseObjectKeys {

  static const String id = "id";
  static const String time = "time";
  static const String isAssigned = "isAssigned";
  static const String isCompleted = "isCompleted";
  static const String isCancelled = "isCancelled";
  static const String task = "task";

}

class Activity extends BaseObject {

  DateTime time;
  bool isAssigned;
  bool isCompleted;
  bool isCancelled;
  Task task;

  Activity (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);

    time = dateFromJson(json[ActivityKeys.time]);
    isAssigned = json[ActivityKeys.isAssigned];
    isCompleted = json[ActivityKeys.isCompleted];
    isCancelled = json[ActivityKeys.isCancelled];
    task = parseObject(json[ActivityKeys.task], toObject: (Map map) {
      return Task(map);
    });

  }

  @override
  Map toMap() {
    return {
      ActivityKeys.id: id,
      ActivityKeys.task: objectMap(task),
      ActivityKeys.time: jsonValueOfDate(time),
      ActivityKeys.isAssigned: isAssigned,
      ActivityKeys.isCompleted: isCompleted,
      ActivityKeys.isCancelled: isCancelled
    };
  }
}