import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FOrderByMenu extends StatelessWidget {
  final OrderBy? current;
  final List<OrderBy> options;
  final Function(OrderBy?) onTap;

  const FOrderByMenu({
    super.key,
    required this.current,
    required this.options,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = current != null;
    final icon = current?.icon ?? MdiIcons.sortVariant;
    final label =
        current?.getName(context) ?? context.l10n.f_order_by_menu__label;
    return MenuAnchor(
      builder: (_, controller, _) => FilterChip(
        avatar: Icon(icon),
        showCheckmark: false,
        label: Text(label),
        deleteIcon: const Icon(MdiIcons.close),
        onDeleted: selected ? () => onTap.call(null) : null,
        selected: selected,
        onSelected: (_) => toggleState(controller),
      ),
      menuChildren: [
        for (final option in options)
          MenuItemButton(
            leadingIcon: Icon(option.icon),
            child: Text(option.getName(context)),
            onPressed: () => onTap.call(option),
          ),
      ],
    );
  }

  void toggleState(MenuController controller) {
    controller.isOpen ? controller.close() : controller.open();
  }
}
