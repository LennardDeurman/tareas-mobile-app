import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/widgets/text_with_icon.dart';
class TaskCell extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Material(child: InkWell(child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: BrandColors.inputColor
          )
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Goals plaatsen",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              TextWithIcon(
                iconData: FontAwesomeIcons.clock,
                text: "Vandaag 12:25",
                fontSize: 12,
                iconMargin: EdgeInsets.symmetric(
                  horizontal: 5
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: Text(
                "Het plaatsen van de goals op de velden:  A1, B3, G4.",
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ),
        ],
      ),
    ), onTap: () {

    }), color: Colors.white);
  }

}