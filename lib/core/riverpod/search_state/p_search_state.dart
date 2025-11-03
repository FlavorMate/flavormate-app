import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_search_state.g.dart';

@riverpod
class PSearchState extends _$PSearchState {
  @override
  String build(String searchId) {
    return '';
  }

  void set(String? value) {
    state = value ?? '';
  }
}
