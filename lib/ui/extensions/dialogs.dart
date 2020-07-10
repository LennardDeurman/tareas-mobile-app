import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/ui/extensions/buttons.dart';
import 'package:tareas/ui/lists/categories.dart';

class PreferencesDialog extends StatelessWidget {

  final SelectionDelegate<Category> selectionDelegate;
  final Function onSave;

  PreferencesDialog ({ this.onSave, this.selectionDelegate });

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                        FlutterI18n.translate(context, TranslationKeys.categories).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  Container(
                    child: Text(FlutterI18n.translate(context, TranslationKeys.categoriesInfo),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16
                        )
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: 6
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 15
                    ),
                    child: CategoriesList(
                      selectionDelegate: selectionDelegate,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 15
                    ),
                    child: Container(child:
                      PrimaryButton(
                        iconData: FontAwesomeIcons.save,
                        text: FlutterI18n.translate(context, TranslationKeys.save),
                        color: BrandColors.primaryColor,
                        onPressed: onSave
                      ), width: double.infinity
                    ),
                  )
                ]
            ),
          ),
        )
      ],

    ), color: Colors.transparent);
  }
}