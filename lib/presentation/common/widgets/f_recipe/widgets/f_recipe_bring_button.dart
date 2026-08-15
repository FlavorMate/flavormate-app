import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FRecipeBringButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? width;
  final double height;

  static const Color _color = Color.fromARGB(255, 51, 69, 78);

  const FRecipeBringButton({
    required this.onPressed,
    this.height = 40,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: M3EButton(
        onPressed: onPressed,
        decoration: .styleFrom(
          backgroundColor: _color,
          foregroundColor: Colors.white,
          minimumSize: .fromHeight(height),
        ),
        child: Row(
          spacing: PADDING / 2,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Assets.icons.bring.image(height: 18),
            ),
            Expanded(
              child: Text(
                context.l10n.f_recipe_bring_button__title,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
