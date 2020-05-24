import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tareas/extensions/asset_paths.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/extensions/custom_fonts.dart';
import 'package:tareas/pages/home.dart';
import 'package:tareas/pages/login.dart';

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

class MainApp extends StatelessWidget {

  final FlutterI18nDelegate flutterI18nDelegate;

  MainApp (this.flutterI18nDelegate);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tareas", //We can't use the translation here already
      theme: ThemeData(
        fontFamily: CustomFonts.openSans,
      ),
      home: LoginPage(),
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ]
    );
  }


}

