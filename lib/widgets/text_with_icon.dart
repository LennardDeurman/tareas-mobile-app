import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:tareas/extensions/brand_colors.dart';

class TextWithIcon extends StatefulWidget {

  final IconData iconData;
  final double iconSize;
  final double fontSize;
  final EdgeInsets iconMargin;
  final EdgeInsets textMargin;
  final String text;
  final Color color;
  final Color selectedColor;
  final bool selected;
  final Function onPressed;
  final FontWeight fontWeight;


  TextWithIcon ({ @required this.iconData, @required this.text, this.onPressed, this.iconSize = 18, this.fontSize = 16, this.fontWeight = FontWeight.normal, this.color = BrandColors.textLabelColor, this.selectedColor = BrandColors.primaryColor, this.selected = false, this.iconMargin, this.textMargin, GlobalKey key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextWithIconState();
  }

}

class TextWithIconState extends State<TextWithIcon> {

  Color _currentColor;

  @override
  void initState() {
    super.initState();
    if (widget.selected) {
      _currentColor = widget.selectedColor;
    } else {
      _currentColor = widget.color;
    }
  }

  Widget _buildTextWithIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: FaIcon(
            widget.iconData,
            size: widget.iconSize,
            color: _currentColor,
          ),
          margin: widget.iconMargin,
        ),
        Container(
          child: Text(
            widget.text,
            style: TextStyle(
                fontSize: widget.fontSize,
                color: _currentColor,
                fontWeight: widget.fontWeight
            ),
          ),
          margin: widget.textMargin,
        )
      ],
    );
  }

  set active (bool value) {
    if (value) {
      setState(() {
        _currentColor = widget.selectedColor;
      });
    } else {
      setState(() {
        _currentColor = widget.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onPressed != null) {
      return GestureDetector(
        child: _buildTextWithIcon(),
        onTapDown: (_) {
          active = true;
        },
        onTapUp: (_) {
          active = false;
        },
        onTapCancel: () {
          active = false;
        },
        onTap: widget.onPressed,
      );
    }
    return _buildTextWithIcon();

  }

}