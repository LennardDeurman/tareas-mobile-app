import 'package:tareas/models/abstract.dart';

class RequirementKeys {

  static const String description = "description";

}

abstract class Requirement extends BaseObject {

  String description;

  Requirement (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);
    description = json[RequirementKeys.description];
  }

}
