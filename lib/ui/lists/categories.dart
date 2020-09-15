import 'package:flutter/material.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/asset_paths.dart';
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
        return Wrap(
          runSpacing: 12,
          spacing: 8,
          children: () {
            return AuthService().categoriesProvider.categories.map((e) {
              return PrimaryButton(
                color: selectionDelegate.isSelected(e) ? BrandColors.selectedColor : BrandColors.notSelectedColor,
                iconData: IconAssetPaths.check,//TareasIcons.categoryIcons[e.name],
                text: e.name,
                onPressed: () {
                  selectionDelegate.toggle(e);
                },
              );
            }).toList();
          }(),
        );
      },
    );
  }

}