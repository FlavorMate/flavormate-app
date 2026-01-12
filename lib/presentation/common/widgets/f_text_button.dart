import 'package:flavormate/core/config/input_type/input_type_aware_app.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String value;

  const FTextButton({
    super.key,
    required this.onPressed,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isTouch = InputTypeAwareApp.of(context).isTouch;

    if (isTouch) {
      return TextButton(onPressed: onPressed, child: Text(value));
    } else {
      return GestureDetector(
        onTap: onPressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: FText(
            value,
            style: .bodyMedium,
            color: .onPrimaryContainer,
          ),
        ),
      );
    }
  }
}
