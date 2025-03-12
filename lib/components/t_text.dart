import 'package:flutter/material.dart';

enum TextStyles {
  labelSmall,
  labelMedium,
  labelLarge,
  bodySmall,
  bodyMedium,
  bodyLarge,
  headlineSmall,
  headlineMedium,
  headlineLarge,
  displaySmall,
  displayMedium,
  displayLarge,
  titleSmall,
  titleMedium,
  titleLarge,
}

enum TextColor {
  surfaceContainerHighest,
  onPrimaryContainer,
  filledButton,
  white,
  black,
}

class TText extends StatelessWidget {
  final String label;
  final TextStyles style;
  final TextColor? color;
  final TextAlign? textAlign;

  const TText(this.label, this.style, {this.textAlign, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      style: getStyle(
        context,
        style,
      )?.copyWith(color: getColor(context, color), height: 1),
    );
  }

  static TextStyle? getStyle(BuildContext context, TextStyles style) {
    switch (style) {
      case TextStyles.labelSmall:
        return Theme.of(context).textTheme.labelSmall;
      case TextStyles.labelMedium:
        return Theme.of(context).textTheme.labelMedium;
      case TextStyles.labelLarge:
        return Theme.of(context).textTheme.labelLarge;
      case TextStyles.bodySmall:
        return Theme.of(context).textTheme.bodySmall;
      case TextStyles.bodyMedium:
        return Theme.of(context).textTheme.bodyMedium;
      case TextStyles.bodyLarge:
        return Theme.of(context).textTheme.bodyLarge;
      case TextStyles.headlineSmall:
        return Theme.of(context).textTheme.headlineSmall;
      case TextStyles.headlineMedium:
        return Theme.of(context).textTheme.headlineMedium;
      case TextStyles.headlineLarge:
        return Theme.of(context).textTheme.headlineLarge;
      case TextStyles.displaySmall:
        return Theme.of(context).textTheme.displaySmall;
      case TextStyles.displayMedium:
        return Theme.of(context).textTheme.displayMedium;
      case TextStyles.displayLarge:
        return Theme.of(context).textTheme.displayLarge;
      case TextStyles.titleSmall:
        return Theme.of(context).textTheme.titleSmall;
      case TextStyles.titleMedium:
        return Theme.of(context).textTheme.titleMedium;
      case TextStyles.titleLarge:
        return Theme.of(context).textTheme.titleLarge;
    }
  }

  static Color? getColor(BuildContext context, TextColor? color) {
    if (color == null) return null;

    switch (color) {
      case TextColor.filledButton:
        return Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).colorScheme.onPrimary;
      case TextColor.onPrimaryContainer:
        return Theme.of(context).colorScheme.onPrimaryContainer;
      case TextColor.surfaceContainerHighest:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
      case TextColor.white:
        return Colors.white;
      case TextColor.black:
        return Colors.black;
    }
  }
}
