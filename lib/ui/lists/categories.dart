import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/ui/extensions/buttons.dart';

class CategoriesList extends StatelessWidget {

  final SelectionDelegate<Category> selectionDelegate;

  CategoriesList ({ this.selectionDelegate });

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SelectionDelegate>(
      model: selectionDelegate,
      child: ScopedModelDescendant<SelectionDelegate>(
        builder: (context, widget, manager) {
          return Wrap(
            runSpacing: 12,
            spacing: 8,
            children: () {
              return AuthService().categoriesProvider.categories.map((e) {
                return PrimaryButton(
                  color: selectionDelegate.isSelected(e) ? BrandColors.selectedColor : BrandColors.notSelectedColor,
                  iconData: FontAwesomeIcons.clock,
                  text: e.name,
                  onPressed: () {
                    selectionDelegate.toggle(e);
                  },
                );
              }).toList();
            }(),
          );
        },
      ),
    );
  }

}