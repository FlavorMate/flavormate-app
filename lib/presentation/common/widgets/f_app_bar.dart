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
  final bool enableScrollColor;

  final ScrollController? scrollController;

  MouseCursor get _cursor =>
      scrollController != null ? SystemMouseCursors.click : .defer;

  const FAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showHome = true,
    this.automaticallyImplyLeading = true,
    this.enableScrollColor = true,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: showHome ? getBackButton(context) : null,
      centerTitle: true,
      notificationPredicate: enableScrollColor
          ? defaultScrollNotificationPredicate
          : (_) => false,
      actionsPadding: const .symmetric(horizontal: PADDING),
      actions: actions,

      title: MouseRegion(
        cursor: _cursor,
        child: GestureDetector(
          onTap: () => scrollToTop(),
          child: FText(
            title,
            style: .titleLarge,
            fontWeight: .w600,
            fontRoundness: 100,
          ),
        ),
      ),
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

  void scrollToTop() {
    scrollController?.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
}
