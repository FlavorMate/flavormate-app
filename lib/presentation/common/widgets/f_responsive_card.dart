import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:material_3_expressive/components/cards/m3e_cards.dart';
import 'package:material_ui/material_ui.dart';

class FResponsiveCard extends StatelessWidget {
  final Widget child;

  const FResponsiveCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final showCard = constraint.maxWidth >= FBreakpoint.smValue;
        return FResponsive(child: _build(showCard, context));
      },
    );
  }

  Widget _build(bool showCard, BuildContext context) {
    if (showCard) {
      return M3ECard(
        variant: .filled,
        padding: const .all(PADDING * 1.5),
        color: context.colorScheme.surfaceContainer,
        child: child,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(PADDING),
        child: child,
      );
    }
  }
}
