import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_logo.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FLoading extends StatelessWidget {
  const FLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: PADDING,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const FLogo(size: 96),
          FText(
            L10n.of(context).f_loading__title,
            style: FTextStyle.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
