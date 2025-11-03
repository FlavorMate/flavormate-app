import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

enum NutritionType {
  carbohydrates(MdiIcons.corn, Color(0xFFFFD1A9), Color(0xFFFF8E62)),
  sugars(MdiIcons.cubeOutline, Color(0xFFFDC7B0), Color(0xFFFF826D)),
  energyKcal(MdiIcons.fire, Color(0xFFF4B3B3), Color(0xFFE57373)),
  fat(MdiIcons.waterOutline, Color(0xFFFFF5CC), Color(0xFFFFD966)),
  saturatedFat(
    MdiIcons.foodDrumstickOutline,
    Color(0xFFFDC7B0),
    Color(0xFFFF826D),
  ),
  fiber(MdiIcons.leaf, Color(0xFFB9E4C9), Color(0xFF76C7A2)),
  proteins(MdiIcons.peanutOutline, Color(0xFFA8D8EB), Color(0xFF5EB3D4)),
  salt(MdiIcons.shakerOutline, Color(0xFFE3E3E3), Color(0xFFA9A9A9)),
  sodium(MdiIcons.flaskOutline, Color(0xFFD8C2AC), Color(0xFFC19A76));

  final IconData icon;
  final Color colorLight;
  final Color colorDark;

  const NutritionType(this.icon, this.colorLight, this.colorDark);

  String getName(BuildContext context) {
    return switch (this) {
      NutritionType.carbohydrates => L10n.of(context).nutrition__carbohydrates,
      NutritionType.energyKcal => L10n.of(context).nutrition__kcal,
      NutritionType.fat => L10n.of(context).nutrition__fats,
      NutritionType.saturatedFat => L10n.of(context).nutrition__fats_saturated,
      NutritionType.sugars => L10n.of(context).nutrition__sugars,
      NutritionType.fiber => L10n.of(context).nutrition__fibers,
      NutritionType.proteins => L10n.of(context).nutrition__proteins,
      NutritionType.salt => L10n.of(context).nutrition__salt,
      NutritionType.sodium => L10n.of(context).nutrition__sodium,
    };
  }

  Color getColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? colorLight
        : colorDark;
  }
}
