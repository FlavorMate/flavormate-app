import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_search_term.g.dart';

@Riverpod(keepAlive: true)
class PRecipeSearchTerm extends _$PRecipeSearchTerm {
  @override
  String build() {
    return '';
  }

  void set(String val) {
    state = val;
  }
}
