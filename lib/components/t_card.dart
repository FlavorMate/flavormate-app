import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onTap;
  final double padding;

  const TCard({
    super.key,
    required this.child,
    this.color,
    this.onTap,
    this.padding = PADDING,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(padding),
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
