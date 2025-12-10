import 'package:flutter/material.dart';

class FTile {
  final String label;
  final String subLabel;

  final IconData icon;

  final VoidCallback onTap;

  const FTile({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.onTap,
  });
}
