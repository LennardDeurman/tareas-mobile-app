import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/widgets/text_with_icon.dart';
import 'package:tareas/widgets/headings/page_heading_box.dart';
import 'package:tareas/extensions/translation_keys.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OpenTasksPageHeadingBox extends PageHeadingBox {

  final Function onCalendarPressed;
  final Function onPreferencesPressed;

  final GlobalKey<TextWithIconState> calendarActionKey = GlobalKey<TextWithIconState>();
  final GlobalKey<TextWithIconState> preferencesActionKey = GlobalKey<TextWithIconState>();

  OpenTasksPageHeadingBox ({ @required String title, @required this.onCalendarPressed, @required this.onPreferencesPressed, GlobalKey key }) : super(title: title, key: key);

  @override
  List<Widget> buildAppBarChildren(BuildContext context) {
    return [
      buildTitle(),
      _buildActions(context)
    ];
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: <Widget>[
        TextWithIcon(
            iconData: FontAwesomeIcons.calendar,
            key: calendarActionKey,
            text: FlutterI18n.translate(context, TranslationKeys.calendar),
            color: Colors.black,
            iconMargin: EdgeInsets.only(
                right: 10
            ),
            onPressed: onCalendarPressed
        ),
        SizedBox(
          width: 30,
        ),
        TextWithIcon(
          iconData: FontAwesomeIcons.slidersH,
          key: preferencesActionKey,
          text: FlutterI18n.translate(context, TranslationKeys.preferences),
          color: Colors.black,
          iconMargin: EdgeInsets.only(
              right: 10
          ),
          onPressed: onPreferencesPressed,
        )
      ],
    );
  }



}
