import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

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
    final resolvedLeading = automaticallyImplyLeading
        ? _maybeBackButton(context, showHome: showHome)
        : null;

    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: resolvedLeading,
      centerTitle: true,
      notificationPredicate: enableScrollColor
          ? defaultScrollNotificationPredicate
          : (_) => false,
      actionsPadding: const .symmetric(horizontal: PADDING / 2),
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

  void scrollToTop() {
    scrollController?.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Widget? _maybeBackButton(BuildContext context, {bool showHome = false}) {
    if (kIsTest) {
      return M3EIconButton(
        onPressed: () {},
        icon: const Icon(Symbols.arrow_back_rounded),
      );
    }

    final canPop = Navigator.maybeOf(context)?.canPop() ?? false;
    if (!canPop) {
      return showHome
          ? M3EIconButton(
              onPressed: () => context.routes.home(replace: true),
              icon: const Icon(Symbols.home_rounded),
            )
          : null;
    }

    return M3EIconButton(
      icon: const BackButtonIcon(),
      onPressed: () => Navigator.maybeOf(context)?.maybePop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}
