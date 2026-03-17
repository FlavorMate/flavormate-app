import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FGuideCardCarousel extends StatelessWidget {
  const FGuideCardCarousel({
    super.key,
    required this.currentKey,
    required this.slideDirection,
    required this.height,
    required this.child,
  });

  final ValueKey currentKey;
  final int slideDirection;
  final double height;
  final Widget child;

  static const _distance = 1.1;
  static const _duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AnimatedSwitcher(
        duration: _duration,
        switchInCurve: Curves.linear,
        switchOutCurve: Curves.linear,
        transitionBuilder: (child, animation) {
          final isCurrentChild = child.key == currentKey;

          final enterOffset = Offset(
            slideDirection > 0 ? _distance : -_distance,
            0,
          );
          final exitOffset = Offset(
            slideDirection > 0 ? -_distance : _distance,
            0,
          );

          final offsetAnimation = isCurrentChild
              ? Tween<Offset>(
                  begin: enterOffset,
                  end: Offset.zero,
                ).animate(animation)
              : Tween<Offset>(
                  begin: Offset.zero,
                  end: exitOffset,
                ).animate(ReverseAnimation(animation));

          return ClipRect(
            child: SlideTransition(
              position: offsetAnimation,
              child: Padding(
                padding: const EdgeInsets.all(PADDING),
                child: child,
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }
}
