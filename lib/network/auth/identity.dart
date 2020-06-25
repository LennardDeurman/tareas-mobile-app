import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tareas/network/auth/service.dart';

class AuthorizationError implements Exception {

  final String message;

  AuthorizationError (this.message);
}

class IdentityResult {
  //{sub: auth0|5ee5641dc65c8700139d80ea, email: lennarddeurman@live.nl, email_verified: false}

  String sub;
  String email;
  bool emailVerified;


  IdentityResult (Map map) {
    sub = map["sub"];
    email = map["email"];
    emailVerified = map["email_verified"];
  }

}

class IdentityRequest {

  final AuthResult authResult;

  IdentityRequest (this.authResult);

  Future<IdentityResult> fetch() async {
    var response = await http.get(
        "${AuthService.baseUrl}/userinfo",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authResult.accessToken}'
        }
    );
    bool unAuthorized = response.statusCode == 401;
    if (unAuthorized) {
      throw AuthorizationError("The account is not active");
    }

    return IdentityResult(json.decode(response.body));
  }

}