import 'package:flutter/material.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/categories.dart';
import 'package:tareas/logic/delegates/selection.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/ui/extensions/buttons.dart';



class CategoriesList extends StatelessWidget {

  final SelectionDelegate<Category> selectionDelegate;

  CategoriesList ({ this.selectionDelegate });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectionDelegate.notifier,
      builder: (BuildContext context, List<Category> results, Widget widget){
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints parentConstraints) {
            return Wrap(
              runSpacing: 12,
              spacing: 8,
              children: () {
                return AuthService().categoriesProvider.categories.map((category) {
                  return PrimaryButton(
                    color: selectionDelegate.isSelected(category) ? BrandColors.selectedColor : BrandColors.notSelectedColor,
                    iconData: Categories.findIconPath(category.name),
                    text: category.name,
                    onPressed: () {
                      selectionDelegate.toggle(category);
                    },
                  );
                }).toList();
              }(),
            );
          },
        );
      },
    );
  }

}