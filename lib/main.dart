import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tareas/extensions/asset_paths.dart';
import 'package:tareas/extensions/custom_fonts.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
      useCountryCode: false,
      fallbackFile: 'nl',
      path: AssetPaths.localization,
      forcedLocale: new Locale('nl'));
  WidgetsFlutterBinding.ensureInitialized();
  await flutterI18nDelegate.load(null);
  runApp(MainApp(flutterI18nDelegate));
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }

}

class AuthResult {

  String idToken;
  String accessToken;
  String refreshToken;
  DateTime expiryDate;


  AuthResult(Map<String, dynamic> map) {
    idToken = map["idToken"];
    accessToken = map["accessToken"];
    refreshToken = map["refreshToken"];
    if (map.containsKey("expiryDate")) {
      expiryDate = DateTime.fromMillisecondsSinceEpoch(
          map["expiryDate"]
      );
    } else if (map.containsKey("expiresIn")) {
      expiryDate = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch + (map["expiresIn"] * 1000)
      );
    }
  }

  Future save() {
    
  }

  static Future<AuthResult> loadCurrent() {

  }

}


class AuthService {

  /*

  To setup auth0 app:

  1. Make sure the Android manifest contains the necessary setting
  2. Make sure info.plist for iOS is changed according to documentation
  3. Add the callbacks urls in the dashboard as valid:

  com.tareas.app://dev-vpji-vk5.eu.auth0.com/android/com.tareas.app/callback
  com.tareas.app://dev-vpji-vk5.eu.auth0.com/ios/com.tareas.app/callback

  Change dev-vpji-vk5.eu.auth0.com to the correct domain

  4. Change the clientId and domain in this class


  In order to change the application login client the following steps are needed:

  1. Change the domain in the Android manifest (for iOS no changes needed)
  2. Change the clientId and domain in the Auth class

   */

  static const String clientId = "Ntdv2VVHrHRGkNvPhGi4l6fd8rF7Eu40";
  static const String domain = "dev-vpji-vk5.eu.auth0.com";
  static const String baseUrl = "https://$domain/";

  final Auth0 auth0 = Auth0(baseUrl: baseUrl, clientId: clientId);

  Future authorize() async {
    return await
    auth0.
    webAuth.
    authorize({
      'audience': 'https://$domain/userinfo',
      'scope': 'openid email offline_access',
    });
  }


  void initialize() async {

    var response = await authorize();

  }


}

class MainApp extends StatelessWidget {

  final FlutterI18nDelegate flutterI18nDelegate;
  final AuthService authService = AuthService();

  MainApp (this.flutterI18nDelegate) {
    authService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tareas", //We can't use the translation here already
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: CustomFonts.openSans
      ),
      home: HomePage(),
      localizationsDelegates: [  
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ]
    );
  }
}

