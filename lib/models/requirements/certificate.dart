import 'package:tareas/models/certificate.dart';
import 'package:tareas/models/requirements/abstract.dart';

class CertificateRequirementKeys {

  static const String id = "id";
  static const String description = "description";
  static const String requiredCertificates = "requiredCertificates";

}

class CertificateRequirement extends Requirement {

  List<Certificate> requiredCertificates;

  CertificateRequirement (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);

    requiredCertificates = parseList(json[CertificateRequirementKeys.requiredCertificates], toObject: (Map map) {
      return Certificate(map);
    });
  }

  @override
  Map toMap() {
    return {
      CertificateRequirementKeys.id: id,
      CertificateRequirementKeys.description: description,
      CertificateRequirementKeys.requiredCertificates: objectsMapList(requiredCertificates)
    };
  }
}