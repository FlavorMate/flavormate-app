import 'package:flavormate/riverpod/go_router/p_go_router.dart';
import 'package:flutter/material.dart';

Locale currentLocalization() {
  final BuildContext context = navigationKey.currentContext!;
  return Localizations.localeOf(context);
}
