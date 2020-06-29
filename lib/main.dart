import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tareas/constants/asset_paths.dart';
import 'package:tareas/constants/custom_fonts.dart';
import 'package:tareas/network/override_client.dart';
import 'package:tareas/pages/startup.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
      useCountryCode: false,
      fallbackFile: 'nl',
      path: AssetPaths.localization,
      forcedLocale: new Locale('nl'));
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides(); //For testing cases
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
            primarySwatch: Colors.blue,
            fontFamily: CustomFonts.openSans
        ),
        home: StartupPage(),
        localizationsDelegates: [
          this.flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ]
    );
  }

}




