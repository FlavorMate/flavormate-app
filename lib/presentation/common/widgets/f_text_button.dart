import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_ui/material_ui.dart';

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
    return M3EButton(style: .text, onPressed: onPressed, child: Text(value));
  }
}
