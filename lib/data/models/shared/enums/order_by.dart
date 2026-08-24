import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

part 'order_by.mapper.dart';

@MappableEnum()
enum OrderBy {
  CreatedOn(Symbols.calendar_month_rounded),
  Label(Symbols.label_rounded),

  // Only used for BookEntity
  Visible(Symbols.visibility_rounded),

  // Only used for AccountEntity
  DisplayName(Symbols.label_rounded),
  Username(Symbols.person_rounded),

  // Only used for AccountEntity (Admin view)
  EMail(Symbols.email),
  LastActivity(Symbols.nest_clock_farsight_analog_rounded),

  // Only used for TokenEntity
  ExpiresAt(Symbols.alarm_rounded),
  Revoked(Symbols.lock_rounded),
  ;

  final IconData icon;

  const OrderBy(this.icon);

  String getName(BuildContext context) {
    return switch (this) {
      OrderBy.CreatedOn => context.l10n.order_by__created_on,
      OrderBy.Label => context.l10n.order_by__label,
      OrderBy.Visible => context.l10n.order_by__visible,
      OrderBy.DisplayName => context.l10n.order_by__display_name,
      OrderBy.LastActivity => context.l10n.order_by__last_activity,
      OrderBy.Username => context.l10n.order_by__username,
      OrderBy.EMail => context.l10n.order_by__email,
      OrderBy.ExpiresAt => context.l10n.order_by__expires_at,
      OrderBy.Revoked => context.l10n.order_by__revoked,
    };
  }
}
