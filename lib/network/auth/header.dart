import 'package:tareas/network/auth/token_provider.dart';

class AuthorizationHeader {

    static String key = "Authorization";

    static String value() {
      return 'Bearer ${TokenProvider.get()}';
    }

    static Map<String, String> map() {
      return {
        key: value()
      };
    }

}