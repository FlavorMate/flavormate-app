import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';

class TLoadingDialog extends StatelessWidget {
  const TLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black.withAlpha(50),
      child: Center(
        child: SizedBox(
          height: 200,
          width: 350,
          child: TCard(
            child: TColumn(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                TText(L10n.of(context).c_search_loading, TextStyles.titleLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
