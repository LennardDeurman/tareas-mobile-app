import 'package:intl/intl.dart';

abstract class ParsableObject {

  ParsableObject (Map json) {
    parse(json);
  }

  void parse(Map json);

  Map toMap();

  List<Map> objectsMapList(List<ParsableObject> objects) {
    if (objects == null)
      return [];
    return objects.map((e) => e.toMap()).toList();
  }

  Map objectMap(ParsableObject object) {
    if (object == null)
      return null;
    return object.toMap();
  }

  List<T> parseList<T>(List list, { T Function(Map map) toObject }) {
    if (list == null)
      return null;
    List<T> items = list.map((e) => toObject(e)).toList();
    return items;
  }

  T parseObject<T>(Map map, { Function(Map map) toObject }) {
    if (map == null)
      return null;
    return toObject(map);
  }

  DateTime dateFromJson(value) {
    if (value != null)
      return DateFormat("yyyy-MM-dd'T'hh:mm").parse(value);
    return null;
  }

  jsonValueOfDate(DateTime dateTime) {
    if (dateTime != null)
      return DateFormat("yyyy-MM-dd'T'hh:mm").format(dateTime);
    return null;
  }


}


class BaseObjectKeys {
  static const String id = "id";
}

abstract class BaseObject extends ParsableObject {

  String id;

  BaseObject (Map json) : super(json);

  @override
  void parse(Map json) {
    id = json[BaseObjectKeys.id];
  }

}



class SimpleObjectKeys  {

  static const String id = "id";
  static const String name = "name";

}

class SimpleObject extends BaseObject {

  String id;
  String name;

  SimpleObject (Map json) : super(json);

  @override
  Map toMap() {
    return {
      SimpleObjectKeys.id: id,
      SimpleObjectKeys.name: name
    };
  }

  @override
  void parse(Map json) {
    super.parse(json);
    name = json[SimpleObjectKeys.name];
  }

}

