import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class FRecipeGuidedDialogActionRow extends StatelessWidget {
  static const HEIGHT = 40.0;
  static const _BTN_WIDTH = 150.0;

  final bool enablePreviousBtn;
  final bool enableNextBtn;

  final VoidCallback onTapPrevious;
  final VoidCallback onTapNext;

  const FRecipeGuidedDialogActionRow({
    super.key,
    required this.enablePreviousBtn,
    required this.enableNextBtn,
    required this.onTapPrevious,
    required this.onTapNext,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        spacing: PADDING,
        mainAxisAlignment: .center,
        children: [
          if (enablePreviousBtn)
            FButton(
              width: _BTN_WIDTH,
              leading: const Icon(
                Symbols.chevron_left_rounded,
              ),
              label: context.l10n.btn_back,
              onPressed: onTapPrevious,
            ),
          if (enableNextBtn)
            FButton(
              width: _BTN_WIDTH,
              trailing: const Icon(
                Symbols.chevron_right_rounded,
              ),
              label: context.l10n.btn_next,
              onPressed: onTapNext,
            )
          else
            FButton(
              width: _BTN_WIDTH,
              leading: const Icon(Symbols.close_rounded),
              label: context.l10n.btn_close,
              onPressed: () => context.pop(),
            ),
        ],
      ),
    );
  }
}
