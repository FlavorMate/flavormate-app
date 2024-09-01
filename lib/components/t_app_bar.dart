import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showHome;

  const TAppBar({
    super.key,
    this.title = '',
    this.actions,
    this.showHome = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showHome ? getBackButton(context) : null,
      centerTitle: true,
      actions: actions,
      title: Text(title),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget? getBackButton(BuildContext context) {
    if (!context.canPop()) {
      return IconButton(
        onPressed: () => context.replaceNamed('home'),
        icon: const Icon(MdiIcons.home),
      );
    }
    return null;
  }
}
