import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TGradient extends StatelessWidget {
  final int alpha;
  final Color color;
  final List<double> steps;

  const TGradient({
    this.alpha = 175,
    this.color = Colors.black,
    this.steps = const [0, 0.2, 0.25, 0.75, 0.8, 1],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    assert(alpha >= 100);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: steps,
          colors: [
            color.withAlpha(alpha),
            color.withAlpha(alpha - 100),
            Colors.transparent,
            Colors.transparent,
            color.withAlpha(alpha - 100),
            color.withAlpha(alpha),
          ],
        ),
      ),
    );
  }
}
