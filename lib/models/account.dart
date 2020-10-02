import 'package:tareas/models/abstract.dart';
import 'package:tareas/models/member.dart';

class AccountKeys {
  static const String email = "email";
  static const String externalUserId = "externalUserId";
  static const String isSuperAdmin = "isSuperAdmin";
  static const String members = "members";
}

class Account extends BaseObject {

  String email;
  String externalUserId;
  bool isSuperAdmin;
  List<Member> members = [];

  Account (Map<String, dynamic> map) : super(map);

  @override
  void parse(Map json) {
    super.parse(json);

    isSuperAdmin = json[AccountKeys.isSuperAdmin];
    externalUserId = json[AccountKeys.externalUserId];
    email = json[AccountKeys.email];
    members = parseList(json[AccountKeys.members], toObject: (Map map) {
      return Member(map);
    });

  }

  @override
  Map toMap() {
    return {
      AccountKeys.email: email,
      AccountKeys.isSuperAdmin: isSuperAdmin,
      AccountKeys.externalUserId: externalUserId,
      AccountKeys.members: members.map((member) => member.toMap()).toList()
    };
  }


}