import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

part 'course.mapper.dart';

@MappableEnum()
enum Course {
  Appetizer(MdiIcons.breadSlice),
  MainDish(MdiIcons.noodles),
  Dessert(MdiIcons.cookie),
  SideDish(MdiIcons.bowlMix),
  Bakery(MdiIcons.baguette),
  Drink(MdiIcons.beer)
  ;

  final IconData icon;

  const Course(this.icon);

  String getName(BuildContext context) {
    return switch (this) {
      Course.Appetizer => context.l10n.course__appetizer,
      Course.MainDish => context.l10n.course__main_dish,
      Course.Dessert => context.l10n.course__dessert,
      Course.SideDish => context.l10n.course__side_dish,
      Course.Bakery => context.l10n.course__bakery,
      Course.Drink => context.l10n.course__drink,
    };
  }

  static String toGqlJson(Course course) {
    return course.name;
  }
}
