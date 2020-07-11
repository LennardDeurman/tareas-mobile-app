import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/constants/brand_colors.dart';

class SocialPoint extends StatelessWidget {

  final int points;

  SocialPoint ({@required this.points});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FaIcon(
          FontAwesomeIcons.star,
          color: BrandColors.secondaryColor,
          size: 32,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10
          ),
          child: Text(
            this.points.toString(),
            style: TextStyle(
                color: BrandColors.secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16
            ),
          ),
        )
      ],
    );
  }
}