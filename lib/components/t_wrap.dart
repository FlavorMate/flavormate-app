import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TWrap extends StatelessWidget {
  final List<Widget> children;

  const TWrap({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: PADDING,
      runSpacing: PADDING,
      children: children,
    );
  }
}
