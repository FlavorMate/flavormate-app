import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe_draft/nutrition/nutrition_draft.dart';
import 'package:flavormate/utils/u_double.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

part 'nutrition.mapper.dart';

@MappableClass()
class Nutrition extends Entity with NutritionMappable {
  final String? openFoodFactsId;

  // Nutritional values per 100g
  final double? carbohydrates;
  final double? energyKcal;
  final double? fat;
  final double? saturatedFat;
  final double? sugars;
  final double? fiber;
  final double? proteins;
  final double? salt;
  final double? sodium;

  Nutrition({
    super.id,
    super.version,
    super.createdOn,
    super.lastModifiedOn,
    this.openFoodFactsId,
    this.carbohydrates,
    this.energyKcal,
    this.fat,
    this.saturatedFat,
    this.sugars,
    this.fiber,
    this.proteins,
    this.salt,
    this.sodium,
  });

  double get sum =>
      0.0 +
      (carbohydrates ?? sugars ?? 0) +
      (fat ?? saturatedFat ?? 0) +
      (fiber ?? 0) +
      (proteins ?? 0) +
      (salt ?? 0) +
      (sodium ?? 0);

  double get carbohydratesPercent => 100 / sum * (carbohydrates ?? sugars ?? 0);

  double get sugarsPercent => 100 / sum * (sugars ?? 0);

  double get fatPercent => 100 / sum * (fat ?? saturatedFat ?? 0);

  double get saturatedFatPercent => 100 / sum * (saturatedFat ?? 0);

  double get fiberPercent => 100 / sum * (fiber ?? 0);

  double get proteinsPercent => 100 / sum * (proteins ?? 0);

  double get saltPercent => 100 / sum * (salt ?? 0);

  double get sodiumPercent => 100 / sum * (sodium ?? 0);

  Nutrition add(Nutrition other) {
    return Nutrition(
      carbohydrates: UDouble.add(carbohydrates, other.carbohydrates),
      energyKcal: UDouble.add(energyKcal, other.energyKcal),
      fat: UDouble.add(fat, other.fat),
      saturatedFat: UDouble.add(saturatedFat, other.saturatedFat),
      sugars: UDouble.add(sugars, other.sugars),
      fiber: UDouble.add(fiber, other.fiber),
      proteins: UDouble.add(proteins, other.proteins),
      salt: UDouble.add(salt, other.salt),
      sodium: UDouble.add(sodium, other.sodium),
    );
  }

  NutritionDraft toDraft() {
    return NutritionDraft(
      openFoodFactsId: openFoodFactsId,
      carbohydrates: carbohydrates,
      energyKcal: energyKcal,
      fat: fat,
      saturatedFat: saturatedFat,
      sugars: sugars,
      fiber: fiber,
      proteins: proteins,
      salt: salt,
      sodium: sodium,
    );
  }

  Nutrition multiply(double d) {
    return Nutrition(
      openFoodFactsId: openFoodFactsId,
      carbohydrates: UDouble.multiply(carbohydrates, d),
      energyKcal: UDouble.multiply(energyKcal, d),
      fat: UDouble.multiply(fat, d),
      saturatedFat: UDouble.multiply(saturatedFat, d),
      sugars: UDouble.multiply(sugars, d),
      fiber: UDouble.multiply(fiber, d),
      proteins: UDouble.multiply(proteins, d),
      salt: UDouble.multiply(salt, d),
      sodium: UDouble.multiply(sodium, d),
    );
  }

  bool get exists {
    return UDouble.isPositive(carbohydrates) ||
        UDouble.isPositive(energyKcal) ||
        UDouble.isPositive(fat) ||
        UDouble.isPositive(saturatedFat) ||
        UDouble.isPositive(sugars) ||
        UDouble.isPositive(fiber) ||
        UDouble.isPositive(proteins) ||
        UDouble.isPositive(salt) ||
        UDouble.isPositive(sodium);
  }

  bool get showChart {
    return UDouble.isPositive(carbohydrates) ||
        UDouble.isPositive(fat) ||
        UDouble.isPositive(saturatedFat) ||
        UDouble.isPositive(sugars) ||
        UDouble.isPositive(fiber) ||
        UDouble.isPositive(proteins) ||
        UDouble.isPositive(salt) ||
        UDouble.isPositive(sodium);
  }
}

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
      NutritionType.carbohydrates => L10n.of(context).nutrition_carbohydrates,
      NutritionType.energyKcal => L10n.of(context).nutrition_kcal,
      NutritionType.fat => L10n.of(context).nutrition_fat,
      NutritionType.saturatedFat => L10n.of(context).nutrition_saturated_fat,
      NutritionType.sugars => L10n.of(context).nutrition_sugars,
      NutritionType.fiber => L10n.of(context).nutrition_fiber,
      NutritionType.proteins => L10n.of(context).nutrition_proteins,
      NutritionType.salt => L10n.of(context).nutrition_salt,
      NutritionType.sodium => L10n.of(context).nutrition_sodium,
    };
  }

  Color getColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? colorLight
        : colorDark;
  }
}
