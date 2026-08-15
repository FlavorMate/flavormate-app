import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FIconCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width;
  final double iconSize;

  final VoidCallback? onTap;

  const FIconCard({
    required this.icon,
    required this.label,
    this.width = 125,
    this.iconSize = 48,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: M3EButton(
        style: .filled,
        decoration: .styleFrom(
          backgroundColor: context.colorScheme.primaryContainer,
          padding: const .all(16),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Column(
          spacing: PADDING / 2,
          children: [
            Icon(
              color: context.colorScheme.onPrimaryContainer,
              icon,
              size: iconSize,
            ),
            Expanded(
              child: Center(
                child: FText(
                  label,
                  style: FTextStyle.bodyMedium,
                  textAlign: TextAlign.center,
                  color: FTextColor.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
