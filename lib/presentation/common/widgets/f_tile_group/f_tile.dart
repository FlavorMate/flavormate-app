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

  final VoidCallback? onTap;

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

  static Widget manual({
    Key? key,
    required bool first,
    required bool last,
    double borderRadius = 16,
    required FTile tile,
  }) {
    final topLeft = first ? borderRadius : 4.0;
    final topRight = first ? borderRadius : 4.0;
    final bottomLeft = last ? borderRadius : 4.0;
    final bottomRight = last ? borderRadius : 4.0;
    return ClipRRect(
      key: key,
      borderRadius: .only(
        topLeft: .circular(topLeft),
        topRight: .circular(topRight),
        bottomLeft: .circular(bottomLeft),
        bottomRight: .circular(bottomRight),
      ),
      child: tile,
    );
  }

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
                fontWeight: .w600,
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
