import 'package:flutter/foundation.dart';

abstract class UTheme {
  static bool supportAccentColor() {
    return !kIsWeb &&
        [
          TargetPlatform.windows,
          TargetPlatform.macOS,
          TargetPlatform.android,
          TargetPlatform.linux,
        ].contains(defaultTargetPlatform);
  }
}
