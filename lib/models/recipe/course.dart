import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
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
  Drink(MdiIcons.beer);

  final IconData icon;

  const Course(this.icon);

  String getName(BuildContext context) {
    return switch (this) {
      Course.Appetizer => L10n.of(context).en_course_appetizer,
      Course.MainDish => L10n.of(context).en_course_main_dish,
      Course.Dessert => L10n.of(context).en_course_dessert,
      Course.SideDish => L10n.of(context).en_course_side_dish,
      Course.Bakery => L10n.of(context).en_course_bakery,
      Course.Drink => L10n.of(context).en_course_drink,
    };
  }
}
