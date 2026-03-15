import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

class FGuideCardAnimation extends StatelessWidget {
  final IconData icon;
  final double height;

  static const _delay = Duration(milliseconds: 450);
  static const _duration = Duration(milliseconds: 300);

  const FGuideCardAnimation({
    super.key,
    required this.icon,
    this.height = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FutureBuilder(
        future: Future.delayed(
          _delay,
          () => true,
        ),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) return const SizedBox.shrink();

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1),
            duration: _duration,
            curve: Curves.easeOutBack,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: Icon(
              icon,
              size: height,
              color: context.colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
