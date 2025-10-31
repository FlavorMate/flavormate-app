import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FMenuAnchor extends StatelessWidget {
  final List<MenuItemButton> children;

  const FMenuAnchor({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (_, controller, _) => IconButton(
        icon: const Icon(MdiIcons.dotsVertical),
        onPressed: () => toggleState(controller),
      ),
      menuChildren: children,
    );
  }

  void toggleState(MenuController controller) {
    controller.isOpen ? controller.close() : controller.open();
  }
}
