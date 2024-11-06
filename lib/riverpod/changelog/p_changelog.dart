import 'dart:convert';

import 'package:flavormate/gen/assets.gen.dart';
import 'package:flavormate/models/changelog/changelog.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_changelog.g.dart';

@riverpod
class PChangelog extends _$PChangelog {
  @override
  Future<Changelog> build() async {
    final language = currentLocalization().languageCode;

    final path = switch (language) {
      'de' => Assets.documents.changelog.de,
      'en' => Assets.documents.changelog.en,
      _ => '',
    };

    final value = await rootBundle.loadString(path);

    final List<dynamic> parsedJson = jsonDecode(value);

    final entries =
        parsedJson.map((map) => ChangelogVersionMapper.fromMap(map)).toList();

    ref.keepAlive();

    return Changelog(entries: {for (var v in entries) v.version: v});
  }
}
