import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/asset_paths.dart';
import 'package:tareas/constants/custom_fonts.dart';
import 'package:tareas/constants/translation_keys.dart';



class BackgroundsBuilder {

  Widget background({ List<Widget> children }) {
    return Container(
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          )
      ),
    );
  }

  Widget illustration(String assetPath) {
    return Container(
      width: 250,
      height: 170,
      child: Image(
        image: AssetImage(
            assetPath
        ),
      ),
    );
  }

  Widget titleLabel(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600
      ),
    );
  }

  Widget descriptionLabel(String text) {
    return Container(
      width: 300,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16
        ),
      ),
    );
  }

  Widget loadingBackground(BuildContext context) {
    return background(
        children: [
          illustration(AssetPaths.listLoading),
          titleLabel(FlutterI18n.translate(context, TranslationKeys.loadingInProgress)),
          descriptionLabel(FlutterI18n.translate(context, TranslationKeys.loadingDescription)),
          Container(
            width: 250,
            margin: EdgeInsets.symmetric(vertical: 25),
            child: LinearProgressIndicator(),
          )
        ]
    );
  }

  Widget noResultsBackground(BuildContext context) {
    return background(
        children: [
          illustration(AssetPaths.listNoResults),
          titleLabel(FlutterI18n.translate(context, TranslationKeys.noResults)),
          descriptionLabel(FlutterI18n.translate(context, TranslationKeys.informationNotAvailable))
        ]
    );
  }

  Widget errorBackground(BuildContext context) {
    return background(
      children: [
        illustration(AssetPaths.listError),
        descriptionLabel(FlutterI18n.translate(context, TranslationKeys.informationNotAvailable))
      ]
    );
  }

}

class SubscribedActivitiesBackgroundsBuilder extends BackgroundsBuilder {

  Widget buildNoResultsDescription(BuildContext context) {
    String baseText = FlutterI18n.translate(context, TranslationKeys.noSubscribedTasks);
    String openTasks = FlutterI18n.translate(context, TranslationKeys.openTasks).toLowerCase().trim();
    int start = baseText.indexOf(openTasks);
    String firstPart = baseText.substring(0, start).trim();
    String lastPart = baseText.substring(start + openTasks.length, baseText.length).trim();


    return Container(
      width: 300,
      child: RichText(
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
      ),
    );

  }

  @override
  Widget noResultsBackground(BuildContext context) {
    return background(
        children: [
          illustration(AssetPaths.listNoSubscribedActivities),
          buildNoResultsDescription(context)
        ]
    );
  }

}