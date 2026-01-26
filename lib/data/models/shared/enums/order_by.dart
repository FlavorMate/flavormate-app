import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

part 'order_by.mapper.dart';

@MappableEnum()
enum OrderBy {
  CreatedOn(MdiIcons.calendar),
  Label(MdiIcons.label),

  // Only used for BookEntity
  Visible(MdiIcons.eye),

  // Only used for AccountEntity
  DisplayName(MdiIcons.label),
  Username(MdiIcons.account),

  // Only used for TokenEntity
  ExpiresAt(MdiIcons.clockEnd),
  Revoked(MdiIcons.lockReset),
  ;

  final IconData icon;

  const OrderBy(this.icon);

  String getName(BuildContext context) {
    return switch (this) {
      OrderBy.CreatedOn => context.l10n.order_by__created_on,
      OrderBy.Label => context.l10n.order_by__label,
      OrderBy.Visible => context.l10n.order_by__visible,
      OrderBy.DisplayName => context.l10n.order_by__display_name,
      OrderBy.Username => context.l10n.order_by__username,
      OrderBy.ExpiresAt => context.l10n.order_by__expires_at,
      OrderBy.Revoked => context.l10n.order_by__revoked,
    };
  }

  static String toGqlJson(OrderBy searchOrderBy) {
    return searchOrderBy.name;
  }
}
