import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
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
            context.l10n.f_search_loading__title,
            style: FTextStyle.titleLarge,
          ),
        ],
      ),
    );
  }
}
