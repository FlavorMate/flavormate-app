import 'package:flavormate/core/navigation/p_go_router.dart';
import 'package:flavormate/data/models/shared/enums/language.dart';
import 'package:material_ui/material_ui.dart';

Locale currentLocalization() {
  final BuildContext context = navigationKey.currentContext!;
  return Localizations.localeOf(context);
}

Language currentLanguage() {
  return Language.values.firstWhere(
    (it) => it.name == currentLocalization().languageCode,
  );
}
