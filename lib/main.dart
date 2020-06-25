import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tareas/extensions/asset_paths.dart';
import 'package:tareas/extensions/custom_fonts.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/pages/welcome.dart';

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

class MainApp extends StatefulWidget {

  final FlutterI18nDelegate flutterI18nDelegate;

  MainApp (this.flutterI18nDelegate);

  @override
  State<StatefulWidget> createState() {
    return _MainAppState();
  }


}

class _MainAppState extends State<MainApp> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Tareas", //We can't use the translation here already
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: CustomFonts.openSans
        ),
        home: WelcomePage(),
        localizationsDelegates: [
          this.widget.flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ]
    );
  }

}



