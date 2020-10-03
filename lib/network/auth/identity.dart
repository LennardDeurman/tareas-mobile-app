import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tareas/models/account.dart';
import 'package:tareas/models/member.dart';
import 'package:tareas/network/account.dart';
import 'package:tareas/network/auth/service.dart';

class AuthorizationError implements Exception {

  final String message;

  AuthorizationError (this.message);

}

class MissingIdentityError implements Exception {

}

class UserInfo {

  String sub;
  String email;
  String accountId;
  bool emailVerified;

  UserInfo (Map map) {
    sub = map["sub"];
    email = map["email"];
    emailVerified = map["email_verified"];
    accountId = map["https://tareas.nl/account_id"];
  }

}


class IdentityResult {

  final UserInfo userInfo;
  final Account account;

  Member _activeMember;

  Member get activeMember {
    return _activeMember;
  }


  static const String preferredMemberIdKey = "preferredMemberIdKey";

  IdentityResult ({ this.userInfo, this.account }) {
    if (account != null) {
      _activeMember = account.members.first;

      SharedPreferences.getInstance().then((instance) {
        String preferredMemberId = instance.get(IdentityResult.preferredMemberIdKey);
        if (preferredMemberId != null) {
          setPreferredMember(
              preferredMemberId
          );
        }
      });
    }
  }

  Future<bool> setPreferredMember(String id, { bool shouldSave = true }) async {
    _activeMember = account.members.firstWhere((member) {
      return member.id == id;
    }, orElse: () {
      return _activeMember;
    });

    bool valid = _activeMember.id == id;
    if (shouldSave) {
      if (valid) {
        var prefInstance = await SharedPreferences.getInstance();
        prefInstance.setString(IdentityResult.preferredMemberIdKey, id);
      }
    }

    return valid;
  }



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
    AccountFetcher fetcher = AccountFetcher();
    Completer<IdentityResult> completer = Completer();

    try {
      UserInfo userInfo = await fetchUserInfo();
      Account account = await fetcher.get(userInfo.accountId);
      var result = IdentityResult(
          account: account,
          userInfo: userInfo
      );
      completer.complete(result);
    } catch (e) {
      completer.completeError(e);
    }


    return completer.future;
  }

}