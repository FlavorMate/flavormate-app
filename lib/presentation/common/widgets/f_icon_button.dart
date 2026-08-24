import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  final String? label;
  final double? width;
  final double height;

  const FIconButton({
    required this.onPressed,
    required this.icon,
    this.label,
    this.height = 40,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return M3EIconButton(
        variant: .filled,
        icon: Icon(
          icon,
          color: FTextColor.filledButton.getThemeColor(context),
        ),
        onPressed: onPressed,
      );
    } else {
      return SizedBox(
        width: width,
        child: M3EButton(
          onPressed: onPressed,
          decoration: width?.let(
            (it) => .styleFrom(minimumSize: .new(it, height)),
          ),
          child: Row(
            spacing: PADDING / 2,
            children: [
              Icon(icon),
              Expanded(child: Text(label!, textAlign: TextAlign.center)),
            ],
          ),
        ),
      );
    }
  }
}
