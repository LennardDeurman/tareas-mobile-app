import 'package:flutter/material.dart';
import 'package:tareas/ui/extensions/labels.dart';

class PrimaryButton extends StatelessWidget {

  final IconData iconData;
  final String text;
  final Color color;
  final Function onPressed;

  PrimaryButton ({ @required this.iconData, @required this.text, @required this.color, @required this.onPressed });

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