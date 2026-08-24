import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:material_ui/material_ui.dart';

class FTile extends StatelessWidget {
  final FTextColor? foregroundColor;

  final String label;
  final String? subLabel;

  final Widget? leading;
  final Widget? trailing;

  final bool disabled;

  final VoidCallback? onTap;

  const FTile({
    super.key,
    required this.label,
    this.subLabel,
    this.leading,
    this.trailing,
    this.disabled = false,
    this.foregroundColor,
    required this.onTap,
  });

  static Widget manual({
    Key? key,
    required BuildContext context,
    required bool first,
    required bool last,
    required FTile tile,
    Color? backgroundColor,
    bool disabled = false,
  }) {
    return FTileGroup.buildTile(
      context: context,
      first: first,
      last: last,
      backgroundColor: backgroundColor,
      item: tile,
      disabled: disabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: PADDING,
      children: [
        ?leading,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              FText(
                label,
                style: .bodyLarge,
                color: disabled
                    ? .grey
                    : (foregroundColor ?? .onPrimaryContainer),
                fontRoundness: subLabel == null ? 0 : 100,
                fontWeight: subLabel == null ? .normal : .w500,
              ),
              ?subLabel?.let(
                (it) => FText(
                  it,
                  style: .bodyMedium,
                  color: foregroundColor ?? .grey,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
