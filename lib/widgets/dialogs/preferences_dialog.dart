import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/extensions/translation_keys.dart';
import 'package:tareas/widgets/text_with_icon.dart';

class PreferencesDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PreferencesDialogState();
  }

}

class FatButton extends StatelessWidget {

  final IconData iconData;
  final String text;
  final Color color;
  final Function onPressed;

  FatButton ({ @required this.iconData, @required this.text, @required this.color, @required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      child: Container(
        child: TextWithIcon(
          iconData: iconData,
          iconMargin: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 6
          ),
          textMargin: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12
          ),
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      color: color,
      onPressed: onPressed,
    );
  }

}


class _PreferencesDialogState extends State<PreferencesDialog> {

  @override
  Widget build(BuildContext context) {
    return Material(child: Stack(

      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(FlutterI18n.translate(context, TranslationKeys.categories).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    )),
                  ),
                  Container(
                    child: Text(FlutterI18n.translate(context, TranslationKeys.categoriesInfo), textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 16
                    )),
                    margin: EdgeInsets.symmetric(
                      vertical: 6
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 15
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: <Widget>[
                        FatButton(
                          text: "Kantine",
                          color: BrandColors.notSelectedColor,
                          iconData: FontAwesomeIcons.clock,
                          onPressed: () {

                          },
                        ),
                        FatButton(
                          text: "Activiteiten",
                          color: BrandColors.selectedColor,
                          iconData: FontAwesomeIcons.flag,
                          onPressed: () {

                          },
                        ),
                        FatButton(
                          text: "Maatschappelijk",
                          color: BrandColors.notSelectedColor,
                          iconData: FontAwesomeIcons.clock,
                          onPressed: () {

                          },
                        ),
                        FatButton(
                          text: "Sportpark",
                          color: BrandColors.selectedColor,
                          iconData: FontAwesomeIcons.flag,
                          onPressed: () {

                          },
                        ),
                        FatButton(
                          text: "Wedstrijd",
                          color: BrandColors.selectedColor,
                          iconData: FontAwesomeIcons.key,
                          onPressed: () {

                          },
                        ),
                        FatButton(
                          text: "Wedstrijd",
                          color: BrandColors.selectedColor,
                          iconData: FontAwesomeIcons.ellipsisH,
                          onPressed: () {

                          },
                        ),

                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 15
                    ),
                    child: Container(child: FatButton(iconData: FontAwesomeIcons.save, text: FlutterI18n.translate(context, TranslationKeys.save), color: BrandColors.primaryColor, onPressed: () {

                    }), width: double.infinity),
                  )
                ]
            ),
          ),
        )
      ],

    ), color: Colors.transparent);
  }
}