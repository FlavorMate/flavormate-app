import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';

class FBadge extends StatefulWidget {
  final IconData icon;
  final Shapes shape;
  final double radius;
  final int speed;

  const FBadge({
    super.key,
    required this.shape,
    required this.icon,
    this.radius = 64,
    this.speed = 30,
  });

  @override
  State<StatefulWidget> createState() => _FBadgeState();
}

class _FBadgeState extends State<FBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.speed),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: Stack(
        children: [
          Center(
            child: RotationTransition(
              turns: _controller,
              child: M3Container(
                widget.shape,
                color: context.colorScheme.primaryContainer,
                width: widget.radius * 2,
                height: widget.radius * 2,
                child: const SizedBox.shrink(),
              ),
            ),
          ),
          Center(
            child: Icon(
              widget.icon,
              size: widget.radius,
              color: context.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
