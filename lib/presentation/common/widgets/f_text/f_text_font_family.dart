part of 'f_text.dart';

enum FTextFontFamily {
  monospace,
  sansFlex
  ;

  String? geFTextFontFamily() {
    return switch (this) {
      FTextFontFamily.monospace => 'monospace',
      FTextFontFamily.sansFlex => 'GoogleSansFlex',
    };
  }
}
