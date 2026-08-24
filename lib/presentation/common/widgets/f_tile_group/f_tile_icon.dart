import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:material_ui/material_ui.dart';

class FTileIcon extends StatelessWidget {
  final IconData icon;
  final Color? iconBackgroundColor;
  final Color? iconForegroundColor;

  const FTileIcon({
    super.key,
    required this.icon,
    this.iconBackgroundColor,
    this.iconForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor:
          iconBackgroundColor ?? context.colorScheme.primaryContainer,
      child: Icon(
        icon,
        size: 24,
        color: iconForegroundColor ?? context.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
