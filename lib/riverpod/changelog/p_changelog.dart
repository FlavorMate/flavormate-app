import 'dart:convert';

import 'package:flavormate/models/changelog/changelog.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_changelog.g.dart';

@riverpod
class PChangelog extends _$PChangelog {
  @override
  Future<List<Changelog>> build() async {
    final language = currentLocalization().languageCode;

    final value = await rootBundle
        .loadString('assets/documents/changelog/$language.json');

    final List<dynamic> parsedJson = jsonDecode(value);

    return parsedJson.map((map) => ChangelogMapper.fromMap(map)).toList();
  }
}
