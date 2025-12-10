import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

part 'order_direction.mapper.dart';

@MappableEnum()
enum OrderDirection {
  Ascending(MdiIcons.sortAscending),
  Descending(MdiIcons.sortDescending)
  ;

  final IconData icon;

  const OrderDirection(this.icon);

  String getName(BuildContext context) {
    return switch (this) {
      OrderDirection.Ascending => context.l10n.order_direction__ascending,
      OrderDirection.Descending => context.l10n.order_direction__descending,
    };
  }

  static String toGqlJson(OrderDirection direction) {
    return direction.name;
  }
}
