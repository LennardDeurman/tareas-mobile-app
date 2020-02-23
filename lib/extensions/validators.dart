import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/extensions/translation_keys.dart';

class Validators {

  static String passwordValidator(String value, BuildContext context) {
    if (value.length < 6) {
      return FlutterI18n.translate(context, TranslationKeys.passwordTooShort);
    }
    return null;
  }

  static String usernameValidator(String value, BuildContext context) {
    if (value.length < 6) {
      return FlutterI18n.translate(context, TranslationKeys.usernameTooShort);
    }
    return null;
  }

}