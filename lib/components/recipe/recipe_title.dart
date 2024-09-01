import 'package:flavormate/components/t_text.dart';
import 'package:flutter/material.dart';

class RecipeTitle extends StatelessWidget {
  final String title;

  const RecipeTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return TText(title, TextStyles.displayMedium);
  }
}
