import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/email_address.dart';
import 'package:tareas/models/phone_number.dart';

class ParentKeys {

  static const String emailAddresses = "emailAddresses";
  static const String phoneNumbers = "phoneNumbers";

}

class Parent extends SimpleObject {

  List<EmailAddress> emailAddresses;
  List<PhoneNumber> phoneNumbers;

  Parent (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);

    emailAddresses = parseList(json[ParentKeys.emailAddresses], toObject: (Map map) {
      return EmailAddress(map);
    });

    phoneNumbers = parseList(json[ParentKeys.phoneNumbers], toObject: (Map map) {
      return PhoneNumber(map);
    });
  }

  @override
  Map toMap() {
    Map map = super.toMap();
    map[ParentKeys.emailAddresses] = objectsMapList(emailAddresses);
    map[ParentKeys.phoneNumbers] = objectsMapList(phoneNumbers);
    return map;
  }

}