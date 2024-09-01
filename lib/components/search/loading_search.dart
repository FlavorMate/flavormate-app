import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class LoadingSearch extends StatelessWidget {
  const LoadingSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: PADDING),
          TText(L10n.of(context).c_search_loading, TextStyles.titleLarge),
        ],
      ),
    );
  }
}
