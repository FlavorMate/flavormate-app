import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeDescription extends StatelessWidget {
  final String description;

  const FRecipeDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return FText(
      description,
      style: FTextStyle.bodyMedium,
      textAlign: .center,
    );
  }
}
