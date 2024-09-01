import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TColumn extends StatelessWidget {
  final List<Widget?> children;
  final double space;

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;

  const TColumn({
    super.key,
    required this.children,
    this.space = PADDING,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> response = [];

    final elements = children.where((child) => child != null).where((child) {
      if (child! is Visibility) {
        return (child as Visibility).visible;
      }
      return true;
    });

    for (int i = 0; i < elements.length; i++) {
      response.add(elements.elementAt(i)!);
      if (i < elements.length - 1) {
        response.add(SizedBox(height: space));
      }
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: response,
    );
  }
}
