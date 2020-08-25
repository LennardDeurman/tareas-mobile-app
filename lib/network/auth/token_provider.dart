import 'package:tareas/network/auth/service.dart';

class TokenProvider {

  static String get({ String defaultValue = "" }) {
    var service = AuthService();
    if (service != null) {
      if (service.authResult != null) {
        return service.authResult.accessToken;
      }
    }
    return defaultValue;
  }

}