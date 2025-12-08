import 'package:flutter/material.dart';

class FTile {
  final String label;
  final String? subLabel;

  final IconData icon;
  final FTileIconColor? iconColor;

  final VoidCallback onTap;

  const FTile({
    required this.label,
    this.subLabel,
    required this.icon,
    this.iconColor,
    required this.onTap,
  });
}

enum FTileIconColor {
  blue(Color(0xFF67D4FF), Color(0xFF004D68)),
  lightBlue(Color(0xFFA1C9FF), Color(0xFF04409F)),
  pink(Color(0xFFFFAEE4), Color(0xFF8D0053)),
  orange(Color(0xFFFFB683), Color(0xFF753403)),
  yellow(Color(0xFFFCBD00), Color(0xFF6D3A01)),
  green(Color(0xFF80DA88), Color(0xFF00522C)),
  grey(Color(0xFFC7C7C7), Color(0xFF474747)),
  teal(Color(0xFF60D5F3), Color(0xFF004E5D)),
  red(Color(0xFFFFB3AE), Color(0xFF8A1A16)),
  purple(Color(0xFFD9BAFD), Color(0xFF5629A4)),
  ;

  final Color background;
  final Color foreground;

  const FTileIconColor(this.background, this.foreground);
}
