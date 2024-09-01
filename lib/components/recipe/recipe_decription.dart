import 'package:flavormate/components/t_text.dart';
import 'package:flutter/material.dart';

class RecipeDescription extends StatelessWidget {
  final String description;

  const RecipeDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return TText(description, TextStyles.bodyMedium);
  }
}
