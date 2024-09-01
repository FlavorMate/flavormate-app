import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension EBuildContext on BuildContext {
  /// A convenient way to access [ThemeData.colorScheme] of the current context.
  ///
  /// This also prevents confusion with a bunch of other properties of [ThemeData]
  /// that are less commonly used.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// A convenient way to access [ThemeData.textTheme] of the current context.
  ///
  /// This also prevents confusion with a bunch of other properties of [ThemeData]
  /// that are less commonly used.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Shows a floating snack bar with text as its content.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showTextSnackBar(
    String text,
  ) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
      ));

  void showAppLicensePage() => showLicensePage(
        context: this,
        useRootNavigator: true,
        applicationName: 'DummyMart',
      );

  // Custom call a provider for reading method only
  // It will be helpful for us for calling the read function
  // without Consumer,ConsumerWidget or ConsumerStatefulWidget
  // In case if you face any issue using this then please wrap your widget
  // with consumer and then call your provider
  T read<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }
}

extension ThemeModeX on ThemeMode {
  String get label => switch (this) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };
}
