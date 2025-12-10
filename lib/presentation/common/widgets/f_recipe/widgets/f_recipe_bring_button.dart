import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

class FRecipeBringButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? width, height;

  static const Color _color = Color.fromARGB(255, 51, 69, 78);

  const FRecipeBringButton({
    required this.onPressed,
    this.height = 48,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _color,
          foregroundColor: Colors.white,
        ),
        child: Row(
          children: [
            Assets.icons.bring.image(height: 32),
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
