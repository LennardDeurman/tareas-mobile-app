import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tareas/models/member.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/network/members.dart';

class AuthorizationError implements Exception {

  final String message;

  AuthorizationError (this.message);

}

class MissingIdentityError implements Exception {

}

class UserInfo {

  String sub;
  String email;
  String memberId;
  bool emailVerified;

  UserInfo (Map map) {
    sub = map["sub"];
    email = map["email"];
    emailVerified = map["email_verified"];
    memberId = map["https://tareas.nl/member_id"];
  }

}


class IdentityResult {

  UserInfo userInfo;
  Member activeMember;

  IdentityResult ({ this.userInfo, this.activeMember });


}

class IdentityRequest {

  final AuthResult authResult;

  IdentityRequest (this.authResult);

  Future<UserInfo> fetchUserInfo() async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${authResult.accessToken}'
    };
    var response = await http.get(
        "${AuthService.baseUrl}/userinfo",
        headers: headers
    ).timeout(Duration(seconds: 5));
    bool unAuthorized = response.statusCode == 401;
    if (unAuthorized) {
      throw AuthorizationError("The account is not active");
    }

    return UserInfo(json.decode(response.body));
  }

  Future<IdentityResult> fetch() async {
    MembersFetcher fetcher = MembersFetcher();
    Completer<IdentityResult> completer = Completer();

    try {
      UserInfo userInfo = await fetchUserInfo();
      Member member = await fetcher.get(userInfo.memberId);
      var result = IdentityResult(
          activeMember: member,
          userInfo: userInfo
      );
      completer.complete(result);
    } catch (e) {
      completer.completeError(e);
    }


    return completer.future;
  }

}