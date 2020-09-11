import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/icons.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/ui/extensions/buttons.dart';
import 'package:tareas/ui/extensions/dates.dart';
import 'package:tareas/ui/extensions/labels.dart';

class ActivityDetailPage extends StatefulWidget {

  final Activity activity;

  ActivityDetailPage (this.activity);

  @override
  State<StatefulWidget> createState() {
    return _ActivityDetailPageState();
  }

}

class _ActivityDetailPageState extends State<ActivityDetailPage> {

  /*



   */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                  color: Colors.red,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(height: 250, color: Colors.black),
                        Container(height: 250, color: Colors.blue),
                        Container(height: 250, color: Colors.black),
                        Container(height: 250, color: Colors.blue),
                      ],
                    ),
                  ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
                top: 10
              ),
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: true,
                    child: Expanded(
                      child: PrimaryButton(
                        color: BrandColors.primaryColor,
                        iconData: FontAwesomeIcons.check,
                        text: "Accepteren",
                        onPressed: () {

                        },
                      ),
                    )
                  ),
                  Visibility(
                    visible: false,
                    child: SecondaryButton(
                      borderRadius: 7,
                      textMargin: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 5
                      ),
                      iconMargin: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 3
                      ),
                      color: BrandColors.textLabelColor,
                      borderColor: BrandColors.secondarButtonBorderColor,
                      iconData: FontAwesomeIcons.undo,
                      text: "Terugzetten",
                      onPressed: () {

                      },
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: PrimaryButton(
                      borderRadius: 7,
                      textMargin: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 5
                      ),
                      iconMargin: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 3
                      ),
                      color: BrandColors.primaryColor,
                      iconData: FontAwesomeIcons.thumbsUp,
                      text: "Taak afgerond",
                      onPressed: () {

                      },
                    ),
                  ),

                ],
              ),
            )
          ],
        )
      ),
    );
  }

}