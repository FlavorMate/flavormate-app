import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
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
      Diet.Meat => L10n.of(context).diet__meat,
      Diet.Fish => L10n.of(context).diet__fish,
      Diet.Vegetarian => L10n.of(context).diet__vegetarian,
      Diet.Vegan => L10n.of(context).diet__vegan,
    };
  }

  static String toGqlJson(Diet diet) {
    return diet.name;
  }
}
