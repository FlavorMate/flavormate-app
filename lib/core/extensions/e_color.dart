import 'package:material_ui/material_ui.dart';

extension EColor on Color {
  bool isColor(Color other) => toARGB32() == other.toARGB32();
}
