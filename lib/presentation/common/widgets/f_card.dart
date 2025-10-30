import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

class FCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onTap;
  final double padding;
  final double margin;

  const FCard({
    super.key,
    required this.child,
    this.color,
    this.onTap,
    this.padding = PADDING,
    this.margin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? context.colorScheme.primaryContainer,
      margin: EdgeInsets.all(margin),
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
