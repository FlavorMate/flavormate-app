import 'package:flutter/material.dart';

extension EColor on Color {
  bool isColor(Color other) => toARGB32() == other.toARGB32();
}
