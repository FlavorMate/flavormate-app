import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_search_bar_value.g.dart';

@riverpod
class PSearchBarValue extends _$PSearchBarValue {
  @override
  String build() {
    return '';
  }

  void set(String val) {
    state = val;
  }
}
