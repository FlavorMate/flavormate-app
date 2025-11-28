part of 'f_text.dart';

enum FTextColor {
  primary,
  surfaceContainerHighest,
  onPrimaryContainer,
  filledButton,
  white,
  black
  ;

  Color? getThemeColor(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isBright = Theme.of(context).brightness == Brightness.light;

    return switch (this) {
      FTextColor.primary => colorScheme.primary,

      FTextColor.surfaceContainerHighest => colorScheme.surfaceContainerHighest,

      FTextColor.onPrimaryContainer => colorScheme.onPrimaryContainer,

      FTextColor.filledButton =>
        isBright ? Colors.white : colorScheme.onPrimary,

      FTextColor.white => Colors.white,

      FTextColor.black => Colors.black,
    };
  }
}
