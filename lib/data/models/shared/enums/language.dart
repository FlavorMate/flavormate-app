import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

part 'language.mapper.dart';

@MappableEnum()
enum Language {
  en,
  de
  ;

  String getL10n(BuildContext context) {
    return switch (this) {
      .de => context.l10n.lang_de,
      .en => context.l10n.lang_en,
    };
  }

  static List<Language> sorted(BuildContext context) {
    return Language.values.sortedBy(
      (it) => it.getL10n(context),
    );
  }
}
