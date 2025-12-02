import 'package:flutter/material.dart';

class FTile {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const FTile({required this.label, required this.icon, required this.onTap});
}
