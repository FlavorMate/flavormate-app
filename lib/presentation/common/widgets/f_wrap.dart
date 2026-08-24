import 'package:flavormate/core/constants/constants.dart';
import 'package:material_ui/material_ui.dart';

class FWrap extends StatelessWidget {
  final double spacing;
  final double runSpacing;
  final List<Widget> children;

  const FWrap({
    super.key,
    required this.children,
    this.spacing = PADDING,
    this.runSpacing = PADDING,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing,
      runSpacing: runSpacing,
      children: children,
    );
  }
}
