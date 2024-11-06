import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';

class DraftTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get originId => integer().nullable()();

  TextColumn get recipeDraft => text().map(const RecipeDraftConverter())();

  TextColumn get images => text().map(const FileConverter())();

  TextColumn get addedImages => text().map(const FileConverter())();

  TextColumn get removedImages => text().map(const FileConverter())();

  IntColumn get version => integer()();
}

// stores preferences as strings
class RecipeDraftConverter extends TypeConverter<RecipeDraft, String> {
  const RecipeDraftConverter();

  @override
  RecipeDraft fromSql(String fromDb) {
    return RecipeDraftMapper.fromJson(fromDb);
  }

  @override
  String toSql(RecipeDraft value) {
    return value.toJson();
  }
}

class FileConverter extends TypeConverter<List<File>, String> {
  const FileConverter();

  @override
  List<File> fromSql(String fromDb) {
    final List<Map<String, dynamic>> raw = List.from(jsonDecode(fromDb));

    return raw.map((element) => FileMapper.fromMap(element)).toList();
  }

  @override
  String toSql(List<File> value) {
    final raw = jsonEncode(value.map((file) => file.toMap()).toList());
    return raw;
  }
}
