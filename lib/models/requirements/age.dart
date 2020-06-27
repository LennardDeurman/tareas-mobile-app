import 'package:tareas/models/requirements/abstract.dart';

class AgeRequirementKeys {

  static const String id = "id";
  static const String description = "description";
  static const String minimumAge = "minimumAge";
  static const String maximumAge = "maximumAge";
  static const String useMaxAge = "useMaxAge";

}

class AgeRequirement extends Requirement {


  int minimumAge;
  int maximumAge;
  bool useMaxAge;

  AgeRequirement (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);

    minimumAge = json[AgeRequirementKeys.minimumAge];
    maximumAge = json[AgeRequirementKeys.maximumAge];
    useMaxAge = json[AgeRequirementKeys.useMaxAge];
  }

  @override
  Map toMap() {
    return {
      AgeRequirementKeys.id: id,
      AgeRequirementKeys.description: description,
      AgeRequirementKeys.minimumAge: minimumAge,
      AgeRequirementKeys.maximumAge: maximumAge,
      AgeRequirementKeys.useMaxAge: useMaxAge
    };
  }
}