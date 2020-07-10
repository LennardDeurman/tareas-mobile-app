import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/email_address.dart';
import 'package:tareas/models/parent.dart';
import 'package:tareas/models/phone_number.dart';

class ContactInfoKeys {
  static const String contactThroughParents = "contactThroughParents";
  static const String phoneNumbers = "phoneNumbers";
  static const String emailAddresses = "emailAddresses";
  static const String parents = "parents";
}

class ContactInfo extends BaseObject {

  bool contactThroughParents;
  List<PhoneNumber> phoneNumbers;
  List<EmailAddress> emailAddresses;
  List<Parent> parents;

  ContactInfo (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);
    contactThroughParents = json[ContactInfoKeys.contactThroughParents];
    phoneNumbers = parseList(json[ContactInfoKeys.phoneNumbers], toObject: (Map map) {
      return PhoneNumber(map);
    });
    emailAddresses = parseList(json[ContactInfoKeys.emailAddresses], toObject: (Map map) {
      return EmailAddress(map);
    });
    parents = parseList(json[ContactInfoKeys.parents], toObject: (Map map) {
      return Parent(map);
    });
  }

  @override
  Map toMap() {
    return {
      BaseObjectKeys.id: id,
      ContactInfoKeys.contactThroughParents: contactThroughParents,
      ContactInfoKeys.phoneNumbers: objectsMapList(phoneNumbers),
      ContactInfoKeys.emailAddresses: objectsMapList(emailAddresses),
      ContactInfoKeys.parents: objectsMapList(parents)
    };
  }

}