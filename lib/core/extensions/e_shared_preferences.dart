import 'package:shared_preferences/shared_preferences.dart';

extension ESharedPreferences on SharedPreferences {
  T? getEnum<T>(String key, List<Enum> values) {
    final str = getString(key);
    if (str == null) return null;
    return values.byName(str) as T;
  }

  void setEnum(String key, Enum value) {
    setString(key, value.name);
  }
}
