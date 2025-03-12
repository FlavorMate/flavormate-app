import 'package:flavormate/gen/assets.gen.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';

class BringButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? width, height;

  static const Color _color = Color.fromARGB(255, 51, 69, 78);

  const BringButton({
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
                L10n.of(context).c_bring_btn,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
