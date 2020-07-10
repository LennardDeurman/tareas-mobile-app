import 'package:tareas/models/abstract.dart';

class EmailAddressKeys {
  static const String address = "address";
}

class EmailAddress extends BaseObject {

  String address;

  EmailAddress (Map json) : super(json);

  @override
  void parse(Map json) {
    super.parse(json);
    address = json[EmailAddressKeys.address];
  }

  @override
  Map toMap() {
    return {
      BaseObjectKeys.id: id,
      EmailAddressKeys.address: address
    };
  }

}