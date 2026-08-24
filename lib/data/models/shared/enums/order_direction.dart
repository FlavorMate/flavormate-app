import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

part 'order_direction.mapper.dart';

@MappableEnum()
enum OrderDirection {
  Ascending(Symbols.arrow_downward_rounded),
  Descending(Symbols.arrow_upward_rounded);

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
