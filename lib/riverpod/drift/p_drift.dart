import 'package:flavormate/drift/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_drift.g.dart';

@riverpod
class PDrift extends _$PDrift {
  @override
  AppDatabase build() {
    final db = AppDatabase();
    ref.keepAlive();
    return db;
  }
}
