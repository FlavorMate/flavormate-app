import 'package:shared_preferences/shared_preferences.dart';

extension ESharedPreferences on SharedPreferences {
  T? getEnum<T extends Enum>(String key, List<T> values) {
    try {
      final str = getString(key);
      if (str == null) return null;
      return values.byName(str);
    } catch (_) {
      return null;
    }
  }

  Future<bool> setEnum<T extends Enum>(String key, T value) async {
    return await setString(key, value.name);
  }
}
