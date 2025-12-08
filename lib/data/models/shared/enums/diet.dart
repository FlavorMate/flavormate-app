import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

part 'diet.mapper.dart';

@MappableEnum()
enum Diet {
  Meat(MdiIcons.foodDrumstick),
  Fish(MdiIcons.fish),
  Vegetarian(MdiIcons.eggFried),
  Vegan(MdiIcons.foodApple)
  ;

  final IconData icon;

  const Diet(this.icon);

  String getName(BuildContext context) {
    return switch (this) {
      Diet.Meat => context.l10n.diet__meat,
      Diet.Fish => context.l10n.diet__fish,
      Diet.Vegetarian => context.l10n.diet__vegetarian,
      Diet.Vegan => context.l10n.diet__vegan,
    };
  }

  static String toGqlJson(Diet diet) {
    return diet.name;
  }
}
