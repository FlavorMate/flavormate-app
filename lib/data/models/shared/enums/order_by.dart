import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

part 'order_by.mapper.dart';

@MappableEnum()
enum OrderBy {
  CreatedOn(MdiIcons.calendarOutline),
  Label(MdiIcons.labelOutline),

  // Only used for BookEntity
  Visible(MdiIcons.eyeOutline),

  // Only used for AccountEntity
  DisplayName(MdiIcons.labelOutline),
  Username(MdiIcons.accountOutline);

  final IconData icon;

  const OrderBy(this.icon);

  String getName(BuildContext context) {
    return switch (this) {
      OrderBy.CreatedOn => L10n.of(context).order_by__created_on,
      OrderBy.Label => L10n.of(context).order_by__label,
      OrderBy.Visible => L10n.of(context).order_by__visible,
      OrderBy.DisplayName => L10n.of(context).order_by__display_name,
      OrderBy.Username => L10n.of(context).order_by__username,
    };
  }

  static String toGqlJson(OrderBy searchOrderBy) {
    return searchOrderBy.name;
  }
}
