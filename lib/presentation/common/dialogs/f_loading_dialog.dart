import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FLoadingDialog extends StatelessWidget {
  final bool hint;

  const FLoadingDialog({super.key, this.hint = false});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black.withAlpha(50),
      child: Center(
        child: SizedBox(
          height: 200,
          width: 350,
          child: FCard(
            child: Column(
              spacing: PADDING,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                FText(
                  L10n.of(context).f_loading_dialog__loading,
                  style: FTextStyle.titleLarge,
                ),
                if (hint)
                  FText(
                    L10n.of(context).f_loading_dialog__loading_hint,
                    style: FTextStyle.bodyMedium,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
