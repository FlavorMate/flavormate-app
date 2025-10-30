import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FImageInkWell extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final VoidCallback onTap;

  const FImageInkWell({
    super.key,
    required this.height,
    required this.width,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(BORDER_RADIUS),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: Colors.black12,
                  splashColor: Colors.black12,
                  onTap: onTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
