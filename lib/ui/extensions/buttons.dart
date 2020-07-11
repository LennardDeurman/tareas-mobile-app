import 'package:flutter/material.dart';
import 'package:tareas/ui/extensions/labels.dart';

class PrimaryButton extends StatelessWidget {

  final IconData iconData;
  final String text;
  final Color color;
  final Function onPressed;
  final bool isLoading;

  PrimaryButton ({ @required this.iconData, @required this.text, @required this.color, @required this.onPressed, this.isLoading = false });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
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
          );
        }
      }(),
      color: color,
      onPressed: onPressed,
    );
  }

}