


import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tareas/network/auth/identity.dart';
import 'package:tareas/network/categories.dart';
import 'package:tareas/pages/home.dart';
import 'package:tareas/ui/extensions/presentation.dart';


class AuthResultKeys {

  static const String idToken = "id_token";
  static const String accessToken = "access_token";
  static const String refreshToken = "refresh_token";
  static const String expiryDate = "expiry_date";
  static const String expiresIn = "expires_in";
  static const String memberId = "member_id";

}

class AuthResult {

  String idToken;
  String accessToken;
  String refreshToken;
  String memberId;
  DateTime expiryDate;

  static const String cachingKey = "authResultCachingKey";

  AuthResult(Map map) {
    idToken = map[AuthResultKeys.idToken];
    accessToken = map[AuthResultKeys.accessToken];
    refreshToken = map[AuthResultKeys.refreshToken];
    if (map.containsKey(AuthResultKeys.expiryDate)) {
      expiryDate = DateTime.fromMillisecondsSinceEpoch(
          map[AuthResultKeys.expiryDate]
      );
    } else if (map.containsKey(AuthResultKeys.expiresIn)) {
      expiryDate = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch + (map[AuthResultKeys.expiresIn] * 1000)
      );
    }

    //TODO: Load the meta claim for the memberId, remove the following
    memberId = "f1cd2c63-367e-4d0f-a778-e6378064f904";
  }


  int get milliSecondsTillExpiry {
    return expiryDate.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
  }

  bool get isExpired {
    return expiryDate.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch;
  }

  static Future<AuthResult> loadExisting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.get(AuthResult.cachingKey);
    if (jsonString != null){
      Map response = json.decode(jsonString);
      return AuthResult(response);
    }
    return null;
  }

  static Future clearExisting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(AuthResult.cachingKey);
  }


  Map toMap() {
    return {
      AuthResultKeys.expiryDate: expiryDate.millisecondsSinceEpoch,
      AuthResultKeys.accessToken: accessToken,
      AuthResultKeys.refreshToken: refreshToken,
      AuthResultKeys.idToken: idToken,
      AuthResultKeys.memberId: memberId
    };
  }

  Future save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthResult.cachingKey, json.encode(toMap()));
  }


}


class AuthService with AuthServicePresentation {

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
  static const String baseUrl = "https://$domain";

  final Auth0 auth0 = Auth0(baseUrl: baseUrl, clientId: clientId);
  final CategoriesProvider categoriesProvider = CategoriesProvider();

  IdentityResult identityResult;

  AuthResult _cachedAuthResult;
  AuthResult _authResult;
  ValueNotifier<AuthResult> _authResultNotifier = ValueNotifier<AuthResult>(null);
  Timer _expiryCheckTimer;


  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();


  AuthResult get authResult {
    return _authResult;
  }

  set authResult (AuthResult value) {
    _authResult = value;
    _authResultNotifier.value = value;

    if (_expiryCheckTimer != null) {
      _expiryCheckTimer.cancel();
      _expiryCheckTimer = null;
    }

    if (_authResult != null) {
      _expiryCheckTimer = Timer(Duration(
          milliseconds: _authResult.milliSecondsTillExpiry
      ), () {
        if (_authResult.isExpired) {
          //Tell the stream the user status is expired
          logout();
        }
      });
    }
  }

  void registerStateListener(Function function) {
    _authResultNotifier.addListener(function);
  }

  void unregisterStateListener(Function function) {
    _authResultNotifier.removeListener(function);
  }


  Future logout() async {
    Future future = auth0.webAuth.clearSession();
    future.then((value) {
      AuthResult.clearExisting();
      authResult = null;
    }).catchError((e) {
      AuthResult.clearExisting();
      authResult = null;
    });
    return future;
  }

  Future<AuthResult> showUniversalLogin() async {

    var obj = await
    auth0.
    webAuth.authorize({
      'audience': 'https://localhost:44339/',
      'domain': domain,
      'scope': 'openid email offline_access member'
    });


    return AuthResult(obj);
  }

  Future<AuthResult> refreshWithToken(String refreshToken) async {

    var response = await auth0.auth.refreshToken({
      'refreshToken': refreshToken
    });
    return AuthResult(response);

  }

  Future<AuthResult> performRefresh() async {
    return refreshWithToken(authResult.refreshToken).then((value) {
      value.refreshToken = authResult.refreshToken;
      authResult = value;
      authResult.save();
    }).catchError((e) {
      print("Could not refresh the token");
    });
  }

  Future<IdentityResult> performIdentityFetch() async {
    return IdentityRequest(authResult).fetch().then(
            (value) => identityResult = value
    ).catchError((e) {
      print("Fetching the user failed");
      if (e is AuthorizationError) {
        logout();
      }
    });
  }

  Future loadCachedAuthResult() {
    return AuthResult.loadExisting().then((value) => _cachedAuthResult = value);
  }


  Future initialize({ bool forceLoadCache = false }) async {

    if (_cachedAuthResult == null || forceLoadCache) {
      await loadCachedAuthResult();
    }

    authResult = _cachedAuthResult;
    if (authResult == null) {
      authResult = await showUniversalLogin();
      authResult.save();
    } else {
      await performRefresh();
    }

    //await categoriesProvider.load();

    var userInfo = await Auth0Auth(
      clientId,
      baseUrl,
      bearer: authResult.accessToken
    ).getUserInfo();

    await performIdentityFetch();

    if (identityResult == null) {
      throw MissingIdentityError();
    }

    Stream.periodic(Duration(minutes: 5)).listen((event) {
      if (authResult != null) {
        performRefresh();
      }
    });


    Stream.periodic(Duration(minutes: 1)).listen((event) {
      if (authResult != null) {
        performIdentityFetch();
      }
    });

  }


}