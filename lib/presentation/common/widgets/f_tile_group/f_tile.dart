import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FTile extends StatelessWidget {
  final String label;
  final String? subLabel;

  final Widget? leading;
  final Widget? trailing;

  final double? height;

  final bool disabled;

  final VoidCallback onTap;

  const FTile({
    super.key,
    required this.label,
    required this.subLabel,
    this.leading,
    this.trailing,
    this.height,
    this.disabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainer,
      child: ListTile(
        visualDensity: .standard,
        minTileHeight: height,
        onTap: disabled ? null : onTap,
        leading: leading,
        trailing: trailing,
        title: subLabel == null
            ? FText(
                label,
                style: .bodyMedium,
                color: disabled ? .grey : null,
              )
            : FText(
                label,
                style: .bodyLarge,
                weight: .w600,
                color: disabled ? .grey : null,
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
