import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
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
          const SizedBox(height: PADDING / 2),
          const CircularProgressIndicator(),
          FText(
            context.l10n.f_loading__title,
            style: FTextStyle.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
