import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FSearchLoading extends StatelessWidget {
  const FSearchLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: PADDING),
          FText(
            L10n.of(context).f_search_loading__title,
            style: FTextStyle.titleLarge,
          ),
        ],
      ),
    );
  }
}
