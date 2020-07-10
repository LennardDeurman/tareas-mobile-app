import 'package:tareas/models/abstract.dart';

class AddressKeys {

  static const String postalCode = "postalCode";
  static const String houseNumber = "houseNumber";
  static const String houseNumberAddition = "houseNumberAddition";
  static const String streetName = "streetName";
  static const String place = "place";
  static const String country = "country";

}

class Address extends BaseObject {

  String postalCode;
  String houseNumber;
  String houseNumberAddition;
  String streetName;
  String place;
  String country;

  Address (Map map) : super(map);

  @override
  void parse(Map json) {
    super.parse(json);
    postalCode = json[AddressKeys.postalCode];
    houseNumber = json[AddressKeys.houseNumber];
    houseNumberAddition = json[AddressKeys.houseNumberAddition];
    streetName = json[AddressKeys.streetName];
    place = json[AddressKeys.place];
    country = json[AddressKeys.country];
  }

  @override
  Map toMap() {
    return {
      BaseObjectKeys.id: id,
      AddressKeys.postalCode: postalCode,
      AddressKeys.houseNumber: houseNumber,
      AddressKeys.houseNumberAddition: houseNumberAddition,
      AddressKeys.streetName: streetName,
      AddressKeys.place: place,
      AddressKeys.country: country
    };
  }

}