import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeTitle extends StatelessWidget {
  final String title;

  const FRecipeTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return FText(
      title,
      style: FTextStyle.displaySmall,
      textAlign: TextAlign.center,
      weight: FontWeight.bold,
    );
  }
}
