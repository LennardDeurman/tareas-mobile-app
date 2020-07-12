import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/pages/home.dart';
import 'package:tareas/pages/startup.dart';
import 'package:tareas/ui/extensions/buttons.dart';

enum LogoutPresentationStyle {
  transition,
  dialog
}

class LogoutPresenter {

  BuildContext context;
  LogoutPresentationStyle style;

  LogoutPresenter (this.context, { this.style = LogoutPresentationStyle.dialog });

  void register() {
    AuthService().registerStateListener(_authStateListener);
  }

  void unregister() {
    AuthService().unregisterStateListener(_authStateListener);
  }

  void _doTransition() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return StartupPage();
        }
    ), (route) => false);

  }

  void _presentLogout() {
    if (style == LogoutPresentationStyle.dialog) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  FlutterI18n.translate(context, TranslationKeys.loggedOut),
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                        FlutterI18n.translate(context, TranslationKeys.loggedOutMessage)
                    ),
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 35
                    )
                  ),
                  PrimaryButton(
                    color: Colors.red,
                    iconData: FontAwesomeIcons.signOutAlt,
                    text: FlutterI18n.translate(context, TranslationKeys.proceed),
                    onPressed: _doTransition,
                  )
                ],
              )
            );
          }
      );
    } else if (style == LogoutPresentationStyle.transition) {
      _doTransition();
    }
  }

  void _authStateListener() {
    if (AuthService().authResult == null) {
      _presentLogout();
    }
  }

}

class AuthServicePresentation {

  void presentHome(BuildContext context) {
    MaterialPageRoute homeRoute = MaterialPageRoute(
        builder: (BuildContext context) {
          return HomePage();
        }
    );
    Navigator.pushAndRemoveUntil(context, homeRoute, (route) => false);
  }

}