part of 'f_text.dart';

enum FTextStyle {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall;

  TextStyle? geFTextStyle(BuildContext context) {
    final textTheme = context.textTheme;

    return switch (this) {
      FTextStyle.displayLarge => textTheme.displayLarge,
      FTextStyle.displayMedium => textTheme.displayMedium,
      FTextStyle.displaySmall => textTheme.displaySmall,

      FTextStyle.headlineLarge => textTheme.headlineLarge,
      FTextStyle.headlineMedium => textTheme.headlineMedium,
      FTextStyle.headlineSmall => textTheme.headlineSmall,

      FTextStyle.titleLarge => textTheme.titleLarge,
      FTextStyle.titleMedium => textTheme.titleMedium,
      FTextStyle.titleSmall => textTheme.titleSmall,

      FTextStyle.bodyLarge => textTheme.bodyLarge,
      FTextStyle.bodyMedium => textTheme.bodyMedium,
      FTextStyle.bodySmall => textTheme.bodySmall,

      FTextStyle.labelLarge => textTheme.labelLarge,
      FTextStyle.labelMedium => textTheme.labelMedium,
      FTextStyle.labelSmall => textTheme.labelSmall,
    };
  }
}
