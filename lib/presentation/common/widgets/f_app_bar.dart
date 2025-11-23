import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class FAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showHome;
  final bool automaticallyImplyLeading;

  const FAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showHome = true,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: showHome ? getBackButton(context) : null,
      centerTitle: true,
      actions: [
        ...?actions,
        const SizedBox(width: PADDING),
      ],
      title: FText(
        title,
        style: .titleLarge,
        weight: .w500,
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget? getBackButton(BuildContext context) {
    if (!context.canPop()) {
      return IconButton(
        onPressed: () => context.routes.home(replace: true),
        icon: const Icon(MdiIcons.home),
      );
    }
    return null;
  }
}
