import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FWrap extends StatelessWidget {
  final List<Widget> children;

  const FWrap({super.key, required this.children});

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
