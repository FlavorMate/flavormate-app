import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TBubble extends StatelessWidget {
  final Color? color;

  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  final List<Widget> children;

  const TBubble({
    super.key,
    required this.children,
    this.color,
    this.bottomLeft = false,
    this.bottomRight = false,
    this.topLeft = false,
    this.topRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ? 0 : BORDER_RADIUS),
          topRight: Radius.circular(topRight ? 0 : BORDER_RADIUS),
          bottomLeft: Radius.circular(bottomLeft ? 0 : BORDER_RADIUS),
          bottomRight: Radius.circular(bottomRight ? 0 : BORDER_RADIUS),
        ),
      ),
      padding: EdgeInsets.all(PADDING),
      child: TColumn(children: children),
    );
  }
}
