import 'package:flavormate/core/extensions/e_string.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_auth_username.g.dart';

@riverpod
class PAuthUsername extends _$PAuthUsername {
  @override
  String build() {
    return '';
  }

  void set(String val) {
    state = val.trimToBlank;
  }
}
