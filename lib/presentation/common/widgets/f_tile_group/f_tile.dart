import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FTile extends StatelessWidget {
  final String label;
  final String? subLabel;

  final Widget? leading;
  final Widget? trailing;

  final VoidCallback onTap;

  const FTile({
    super.key,
    required this.label,
    required this.subLabel,
    required this.onTap,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainer,
      child: ListTile(
        visualDensity: .standard,
        onTap: onTap,
        leading: leading,
        trailing: trailing,
        title: subLabel == null
            ? FText(label, style: .bodyMedium)
            : FText(
                label,
                style: .bodyLarge,
                weight: .w600,
              ),
        subtitle: subLabel?.let(
          (it) => FText(
            it,
            style: .bodyMedium,
            color: .grey,
          ),
        ),
      ),
    );
  }
}
