import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sp_search_history.g.dart';

@riverpod
class PSPSearchHistory extends _$PSPSearchHistory {
  static final _key = SPKey.SearchHistory.name;

  @override
  List<String> build() {
    final sp = ref.watch(pSPProvider).requireValue;

    return sp.getStringList(_key) ?? [];
  }

  void add(String val) {
    final sp = ref.read(pSPProvider).requireValue;

    final cleanedVal = val.trimToNull?.toLowerCase();

    if (cleanedVal == null) return;

    if (state.any((it) => it == val)) return;

    state.add(val.trim());

    sp.setStringList(_key, state);

    ref.invalidateSelf();
  }

  void remove(String val) {
    final sp = ref.read(pSPProvider).requireValue;

    state.remove(val);

    sp.setStringList(_key, state);

    ref.invalidateSelf();
  }
}
