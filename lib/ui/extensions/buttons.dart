import 'package:flutter/material.dart';
import 'package:tareas/ui/extensions/labels.dart';

class PrimaryButton extends StatelessWidget {

  final String iconData;
  final String text;
  final Color color;
  final Function onPressed;
  final EdgeInsets textMargin;
  final EdgeInsets iconMargin;
  final bool isLoading;
  final double fontSize;
  final double borderRadius;

  PrimaryButton ({ @required this.iconData, @required this.text, @required this.color, @required this.onPressed, this.isLoading = false, this.textMargin, this.iconMargin, this.fontSize, this.borderRadius });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.borderRadius ?? 12)
      ),
      child: () {
        if (isLoading) {
          return Container(child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ), padding: EdgeInsets.all(15));
        } else {
          return Container(
            child: TextWithIcon(
              iconData: iconData,
              iconMargin: iconMargin ?? EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 6
              ),
              textMargin: textMargin ?? EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12
              ),
              text: text,
              fontSize: fontSize ?? 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          );
        }
      }(),
      color: color,
      onPressed: onPressed,
    );
  }

}

class SecondaryButton extends StatelessWidget {

  final String iconData;
  final String text;
  final Color color;
  final Color borderColor;
  final Function onPressed;
  final EdgeInsets textMargin;
  final EdgeInsets iconMargin;
  final bool isLoading;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  SecondaryButton ({ @required this.iconData, @required this.text, @required this.color, @required this.onPressed, this.isLoading = false, this.iconSize = 18, this.textMargin, this.iconMargin, this.fontSize, this.borderRadius, this.borderColor });


  @override
  Widget build(BuildContext context) {
    return OutlineButton(

      borderSide: BorderSide(
        color: this.borderColor ?? color,
        width: 1
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.borderRadius ?? 12)
      ),
      child: Container(
        child: TextWithIcon(
          iconData: iconData,
          iconSize: iconSize,
          iconMargin: iconMargin ?? EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 6
          ),
          textMargin: textMargin ?? EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12
          ),
          text: text,
          fontSize: fontSize ?? 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      color: color,
      onPressed: onPressed,
    );
  }

}