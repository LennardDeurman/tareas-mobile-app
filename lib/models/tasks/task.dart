import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/models/tag.dart';
import 'package:tareas/models/tasks/state.dart';
import 'package:tareas/models/requirements/task_requirement_set.dart';

class TaskKeys {

  static const String id = "id";
  static const String name = "name";
  static const String defaultTaskValue = "defaultTaskValue";
  static const String taskState = "taskState";
  static const String category = "category";
  static const String tags = "tags";
  static const String taskRequirementSet = "taskRequirementSet";
  
}


class Task extends BaseObject {

  String name;
  int defaultTaskValue;
  TaskState taskState;
  Category category;
  List<Tag> tags;
  TaskRequirementSet taskRequirementSet;

  Task (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);
    name = json[TaskKeys.name];
    defaultTaskValue = json[TaskKeys.defaultTaskValue];
    taskState = parseObject(json[TaskKeys.taskState], toObject: (Map map) {
      return TaskState(map);
    });
    category = parseObject(json[TaskKeys.category], toObject: (Map map) {
      return Category(map);
    });
    taskRequirementSet = parseObject(json[TaskKeys.taskRequirementSet], toObject: (Map map) {
      return TaskRequirementSet(map);
    });
    tags = parseList<Tag>(json[TaskKeys.tags], toObject: (Map map) {
      return Tag(map);
    });
  }

  @override
  Map toMap() {
    return {
      TaskKeys.id: id,
      TaskKeys.name: name,
      TaskKeys.defaultTaskValue: defaultTaskValue,
      TaskKeys.taskState: objectMap(taskState),
      TaskKeys.category: objectMap(category),
      TaskKeys.tags: objectsMapList(tags),
      TaskKeys.taskRequirementSet: objectMap(taskRequirementSet)
    };
  }

}
