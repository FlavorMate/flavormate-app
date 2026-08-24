import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onTap;
  final double padding;

  const FCard({
    super.key,
    required this.child,
    this.color,
    this.onTap,
    this.padding = PADDING,
  });

  @override
  Widget build(BuildContext context) {
    return M3ECard(
      color: color ?? context.colorScheme.surfaceContainer,
      variant: .filled,
      onPressed: onTap,
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
    );
  }
}
