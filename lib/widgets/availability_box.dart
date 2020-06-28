import 'package:flutter/material.dart';
import 'package:tareas/extensions/brand_colors.dart';

class AvailabilityBox extends StatelessWidget {

  static const double containerWidth = 48;
  static const double containerHeight = 36;
  static const double roundedItemSize = 34;


  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        _buildItem("Ma"),
        _buildItem("Di", colored: true),
        _buildItem("Wo"),
        _buildItem("Do", colored: true),
        _buildItem("Vr", colored: true),
        _buildItem("Za", colored: true),
        _buildItem("Zo")
      ],
    );
  }

  Widget _buildItem(String title, { bool colored = false }) {
    return Container(
        width: containerWidth,
        height: containerHeight,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: roundedItemSize,
            height: roundedItemSize,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(roundedItemSize / 2),
                color: colored ? BrandColors.primaryColor : Colors.transparent
            ),
            child: Center(
              child: Text(title, style: TextStyle(
                  fontSize: 16,
                  color: colored ? Colors.white : Colors.black
              ),
              ),
            ),
          ),
        ));
  }


}