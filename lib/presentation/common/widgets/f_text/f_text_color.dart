part of 'f_text.dart';

enum FTextColor {
  primary,
  surfaceContainerHighest,
  onPrimaryContainer,
  onInverseSurface,
  filledButton,
  white,
  grey,
  black
  ;

  Color? getThemeColor(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isBright = Theme.of(context).brightness == Brightness.light;

    return switch (this) {
      FTextColor.primary => colorScheme.primary,

      FTextColor.surfaceContainerHighest => colorScheme.surfaceContainerHighest,

      FTextColor.onInverseSurface => colorScheme.inverseSurface,

      FTextColor.onPrimaryContainer => colorScheme.onPrimaryContainer,

      FTextColor.filledButton =>
        isBright ? Colors.white : colorScheme.onPrimary,

      FTextColor.white => Colors.white,

      .grey => Colors.grey.shade600,

      FTextColor.black => Colors.black,
    };
  }
}
