import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flutter/material.dart';

class FResponsiveCard extends StatelessWidget {
  final Widget child;

  const FResponsiveCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final showCard = constraint.maxWidth >= FBreakpoint.smValue;
        return FResponsive(child: _build(showCard));
      },
    );
  }

  Widget _build(bool showCard) {
    if (showCard) {
      return FCard(child: child);
    } else {
      return Padding(
        padding: const EdgeInsets.all(PADDING),
        child: child,
      );
    }
  }
}
