import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/icons.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/ui/extensions/labels.dart';

class OpenActivitiesHeader extends PageHeader {

  final Function onCalendarPressed;
  final Function onPreferencesPressed;

  final GlobalKey<TextWithIconState> calendarButtonKey = GlobalKey<TextWithIconState>();
  final GlobalKey<TextWithIconState> preferencesButtonKey = GlobalKey<TextWithIconState>();

  OpenActivitiesHeader ({ @required String title, @required this.onCalendarPressed, @required this.onPreferencesPressed, GlobalKey key }) : super(title: title, key: key);

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
            iconData: IconAssetPaths.calendarStar,
            key: calendarButtonKey,
            text: FlutterI18n.translate(context, TranslationKeys.calendar),
            color: Colors.black,
            iconSize: 21,
            iconMargin: EdgeInsets.only(
                right: 10
            ),
            onPressed: onCalendarPressed
        ),
        SizedBox(
          width: 30,
        ),
        TextWithIcon(
          iconData: IconAssetPaths.slidersHSquare,
          key: preferencesButtonKey,
          text: FlutterI18n.translate(context, TranslationKeys.preferences),
          color: Colors.black,
          iconSize: 21,
          iconMargin: EdgeInsets.only(
              right: 10
          ),
          onPressed: onPreferencesPressed,
        )
      ],
    );
  }

}


class PageHeader extends StatelessWidget {

  final String title;
  final EdgeInsets padding;

  PageHeader ({
    @required this.title,
    this.padding,
    GlobalKey key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: buildAppBarChildren(context),
      ),
    );
  }

  Widget buildTitle() {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: 15
        ),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600
          ),
        )
    );
  }

  List<Widget> buildAppBarChildren(BuildContext context) {
    return [
      buildTitle()
    ];
  }

}