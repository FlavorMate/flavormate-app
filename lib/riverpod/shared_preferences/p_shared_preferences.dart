import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'p_shared_preferences.g.dart';

@riverpod
class PSharedPreferences extends _$PSharedPreferences {
  @override
  Future<SharedPreferences> build() {
    return SharedPreferences.getInstance();
  }
}
