import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/extensions/translation_keys.dart';
import 'package:tareas/widgets/availability_box.dart';
import 'package:tareas/widgets/headings/page_heading_box.dart';
import 'package:tareas/widgets/social_point_box.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }

}

class _ProfilePageState extends State<ProfilePage> {

  //TODO: Delete button
  //TODO: Sign out button
  //TODO:

  void _signOut() {

  }

  void _deleteAccount() {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: <Widget>[
            PageHeadingBox(
              title: FlutterI18n.translate(context, TranslationKeys.profile),
            ),
            _buildTextCell(label: FlutterI18n.translate(context, TranslationKeys.name), text: "Bert van der Meer"),
            _buildTextCell(label: FlutterI18n.translate(context, TranslationKeys.dateOfBirth), text: "23 maart 1979"),
            _buildTextCell(label: "Arbitrage", text: "Scheidsrecht II en I veldvoetbal"),
            _buildCell(label: FlutterI18n.translate(context, TranslationKeys.availableAtPark), child: _buildCustomCell(
              child: AvailabilityBox()
            )),
            _buildCell(label: FlutterI18n.translate(context, TranslationKeys.socialPoint), child: _buildCustomCell(
              child: SocialPointBox(points: 2144)
            )),
          ],
        ),
      )
    );
  }


  Widget _buildCustomCell({Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 12
      ),
      child: child
    );
  }


  Widget _buildTextCell({@required String label, @required String text}) {
    return _buildCell(
        label: label,
        child: Container(
          child: Text(text,
              style: TextStyle(
                  fontSize: 16
              )
          ),
          margin: EdgeInsets.symmetric(
              vertical: 8
          ),
        )
    );
  }

  Widget _buildCell({@required String label, @required Widget child}) {
    return Container(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: BrandColors.textLabelColor
          ),
        ),
        child
      ],
    ), padding: EdgeInsets.only(
      left: 20,
      right: 20,
      bottom: 20
    ));

  }

}