import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/address.dart';
import 'package:tareas/models/certificate.dart';
import 'package:tareas/models/contact_info.dart';

class CertificationHolderKeys {
  static const String expirationDate = "expirationDate";
  static const String holderId = "holderId";
  static const String certificate = "certificate";
}

class CertificationHolder extends BaseObject {

  DateTime expirationDate;
  Certificate certificate;
  String holderId;

  CertificationHolder (Map json) : super(json);

  @override
  Map toMap() {
    return {
      CertificationHolderKeys.expirationDate: jsonValueOfDate(expirationDate),
      CertificationHolderKeys.certificate: certificate.toMap(),
      CertificationHolderKeys.holderId: holderId
    };
  }

  @override
  void parse(Map json) {
    super.parse(json);
    holderId = json[CertificationHolderKeys.holderId];
    certificate = parseObject(json[CertificationHolderKeys.certificate], toObject: (Map map) {
      return Certificate(map);
    });
    expirationDate = dateFromJson(json[CertificationHolderKeys.expirationDate]);
  }

}

class MemberKeys {
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String age = "age";
  static const String birthDay = "birthDay";
  static const String addresses = "addresses";
  static const String contactInfo = "contactInfo";
  static const String certifications = "certifications";
}

class Member extends BaseObject {

  String firstName;
  String lastName;
  DateTime birthDay;
  int age;
  List<Address> addresses;
  ContactInfo contactInfo;
  List<CertificationHolder> certifications;

  Member (Map map) : super(map);

  @override
  void parse(Map json) {
    super.parse(json);

    firstName = json[MemberKeys.firstName];
    lastName = json[MemberKeys.lastName];
    birthDay = dateFromJson(json[MemberKeys.birthDay]);
    age = json[MemberKeys.age];
    addresses = parseList(json[MemberKeys.addresses], toObject: (Map map) {
      return Address(map);
    });
    certifications = parseList(json[MemberKeys.certifications], toObject: (Map map) {
      return CertificationHolder(map);
    });
    contactInfo = parseObject(json[MemberKeys.contactInfo], toObject: (Map map) {
      return ContactInfo(map);
    });
  }

  @override
  Map toMap() {
    return {
      BaseObjectKeys.id: id,
      MemberKeys.firstName: firstName,
      MemberKeys.lastName: lastName,
      MemberKeys.birthDay: jsonValueOfDate(birthDay),
      MemberKeys.age: age,
      MemberKeys.addresses: objectsMapList(addresses),
      MemberKeys.certifications: objectsMapList(certifications),
      MemberKeys.contactInfo: objectMap(contactInfo)
    };
  }

}