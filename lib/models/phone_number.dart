import 'package:tareas/models/abstract.dart';

class PhoneNumberKeys {

  static const String number = "number";

}

class PhoneNumber extends BaseObject {

  String number;

  PhoneNumber (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);
    number = json[PhoneNumberKeys.number];
  }

  @override
  Map toMap() {
    return {
      PhoneNumberKeys.number: number,
      BaseObjectKeys.id: id
    };
  }

}