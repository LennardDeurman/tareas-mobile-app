import 'package:flutter/material.dart';

class BrandColors {

  static const Color primaryColor = Color.fromRGBO(0, 199, 143, 1);
  static const Color lightCalendarEventColor = Color.fromRGBO(9, 185, 151, 0.33);
  static const Color secondaryColor = Color.fromRGBO(235, 41, 108, 1);
  static const Color inputColor = Colors.black12;
  static const Color errorColor = Colors.red;
  static const Color textLabelColor = Color.fromRGBO(128, 128, 128, 1);
  static const Color secondarButtonBorderColor = Color.fromRGBO(166, 166, 166, 1);
  static const Color overlayColor = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color selectedColor = Color.fromRGBO(0, 162, 238, 1);
  static const Color notSelectedColor = Color.fromRGBO(204, 204, 204, 1);
  static const Color listItemBackgroundColor = Color.fromRGBO(242, 242, 242, 1);
  static const Color iconColor = Color.fromRGBO(0, 151, 222, 1);

  static MaterialColor get primarySwatch {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    Color color = BrandColors.primaryColor;
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}