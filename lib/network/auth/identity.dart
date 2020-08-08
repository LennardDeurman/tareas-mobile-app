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
  bool emailVerified;

  UserInfo (Map map) {
    sub = map["sub"];
    email = map["email"];
    emailVerified = map["email_verified"];
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
    var response = await http.get(
        "${AuthService.baseUrl}/userinfo",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authResult.accessToken}'
        }
    ).timeout(Duration(seconds: 5));
    bool unAuthorized = response.statusCode == 401;
    if (unAuthorized) {
      throw AuthorizationError("The account is not active");
    }

    return UserInfo(json.decode(response.body));
  }

  Future<IdentityResult> fetch() {
    MembersFetcher fetcher = MembersFetcher();
    Completer<IdentityResult> completer = Completer();
    Future.wait(
      [
        fetchUserInfo(),
        fetcher.get(authResult.memberId)
      ]
    ).then((values) {
      UserInfo userInfo = values[0];
      Member member = values[1];
      var result = IdentityResult(
        activeMember: member,
        userInfo: userInfo
      );
      completer.complete(result);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

}