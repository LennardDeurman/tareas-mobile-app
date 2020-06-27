
import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/requirements/age.dart';
import 'package:tareas/models/requirements/certificate.dart';

class TaskRequirementSetKeys {

  static const String id = "id";
  static const String ageRequirements = "ageRequirements";
  static const String certificateRequirements = "certificateRequirements";

}

class TaskRequirementSet extends BaseObject {

  List<AgeRequirement> ageRequirements;
  List<CertificateRequirement> certificateRequirements;

  TaskRequirementSet (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);

    ageRequirements = parseList(json[TaskRequirementSetKeys.ageRequirements], toObject: (Map map) {
      return AgeRequirement(map);
    });

    certificateRequirements = parseList(json[TaskRequirementSetKeys.certificateRequirements], toObject: (Map map) {
      return CertificateRequirement(map);
    });

  }


  @override
  Map toMap() {
    return {
      TaskRequirementSetKeys.id: id,
      TaskRequirementSetKeys.ageRequirements: objectsMapList(ageRequirements),
      TaskRequirementSetKeys.certificateRequirements: objectsMapList(certificateRequirements)
    };
  }


}