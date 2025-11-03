import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

class FBubble extends StatelessWidget {
  final Color? color;

  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  final List<Widget> children;

  const FBubble({
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
    final color = this.color ?? context.colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topLeft) CustomPaint(painter: _Triangle(color)),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeft ? 0 : BORDER_RADIUS),
                topRight: Radius.circular(topRight ? 0 : BORDER_RADIUS),
                bottomLeft: Radius.circular(bottomLeft ? 0 : BORDER_RADIUS),
                bottomRight: Radius.circular(bottomRight ? 0 : BORDER_RADIUS),
              ),
            ),
            padding: const EdgeInsets.all(PADDING),
            child: Column(spacing: PADDING, children: children),
          ),
        ),
        if (topRight) CustomPaint(painter: _Triangle(color)),
      ],
    );
  }
}

class _Triangle extends CustomPainter {
  final Color color;

  const _Triangle(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
