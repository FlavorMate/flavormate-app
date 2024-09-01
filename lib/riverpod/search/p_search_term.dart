import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_search_term.g.dart';

@Riverpod(keepAlive: true)
class PSearchTerm extends _$PSearchTerm {
  @override
  String build() {
    return '';
  }

  void set(String val) {
    state = val;
  }
}
