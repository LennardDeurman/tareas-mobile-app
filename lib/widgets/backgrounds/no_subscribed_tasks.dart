import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/extensions/asset_paths.dart';
import 'package:tareas/extensions/custom_fonts.dart';
import 'package:tareas/extensions/translation_keys.dart';

class NoSubscribedTasksBackground extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: 300
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildImage(),
          _buildText(context)
        ],
      )
    );
  }

  Widget _buildImage() {
    return Container(
      child: Image.asset(AssetPaths.tasksNoResults),
      width: 220,
      height: 200,
    );
  }

  Widget _buildText(BuildContext context) {
    String baseText = FlutterI18n.translate(context, TranslationKeys.noSubscribedTasks);
    String openTasks = FlutterI18n.translate(context, TranslationKeys.openTasks).toLowerCase().trim();
    int start = baseText.indexOf(openTasks);
    String firstPart = baseText.substring(0, start).trim();
    String lastPart = baseText.substring(start + openTasks.length, baseText.length).trim();

    return RichText(
      textAlign: TextAlign.center,

      text: TextSpan(
        style: TextStyle(
            fontSize: 16,
            height: 2,
            color: Colors.black,
            fontFamily: CustomFonts.openSans
        ),
        children: <TextSpan>[
          TextSpan(
            text: firstPart + " "
          ),
          TextSpan(
            text: openTasks,
            style: TextStyle(
              decoration: TextDecoration.underline
            )
          ),
          TextSpan(
            text:  " " + lastPart
          )
        ]
      ),
    );
  }

}