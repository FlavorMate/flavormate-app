import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FButton extends StatelessWidget {
  final Widget? trailing;
  final String label;
  final Widget? leading;

  final bool tonal;

  final VoidCallback? onPressed;

  final double width, height;

  const FButton({
    required this.label,
    required this.onPressed,
    this.tonal = false,
    this.trailing,
    this.leading,
    this.height = 40,
    this.width = double.infinity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: tonal
          ? M3EButton.tonal(
              onPressed: onPressed,
              decoration: .styleFrom(
                minimumSize: .new(width, height),
              ),
              child: _FButtonInternal(
                label: label,
                leading: leading,
                trailing: trailing,
              ),
            )
          : M3EButton(
              onPressed: onPressed,
              decoration: .styleFrom(
                minimumSize: .new(width, height),
              ),
              child: _FButtonInternal(
                label: label,
                leading: leading,
                trailing: trailing,
              ),
            ),
    );
  }
}

class _FButtonInternal extends StatelessWidget {
  final Widget? leading;
  final String label;
  final Widget? trailing;

  const _FButtonInternal({
    this.leading,
    required this.label,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ?leading,
        Expanded(child: Text(label, textAlign: TextAlign.center)),
        ?trailing,
      ],
    );
  }
}
