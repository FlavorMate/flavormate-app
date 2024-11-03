import 'package:flavormate/components/search/loading_search.dart';
import 'package:flavormate/components/search/nothing_found.dart';
import 'package:flavormate/components/search/search_term_too_short.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/search/p_recipe_search.dart';
import 'package:flavormate/riverpod/search/p_recipe_search_term.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeSearch extends ConsumerStatefulWidget {
  final Function(Recipe recipe) onTap;

  const RecipeSearch({super.key, required this.onTap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipeSearchState();
}

class _RecipeSearchState extends ConsumerState<RecipeSearch> {
  final _controller = SearchController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _controller,
      builder: (_, controller) => SearchBar(
        leading: const IconButton(
          icon: Icon(MdiIcons.magnify),
          onPressed: null,
        ),
        hintText: L10n.of(context).c_search_label_recipe,
        onTap: controller.openView,
      ),
      viewHintText: L10n.of(context).c_search_hint,
      viewLeading: IconButton(
        onPressed: close,
        icon: const Icon(MdiIcons.arrowLeft),
      ),
      viewBuilder: (_) => Consumer(
        builder: (_, ref, __) {
          final searchTerm = ref.read(pRecipeSearchTermProvider);
          return ref.watch(pRecipeSearchProvider).when(
              data: (suggestions) => suggestions.isEmpty
                  ? searchTerm.length < 3
                      ? const SearchTermTooShort()
                      : const NothingFound()
                  : ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (_, index) {
                        final suggestion = suggestions[index];
                        return ListTile(
                          title: Text(suggestion.label),
                          leading: Icon(MdiIcons.foodForkDrink),
                          onTap: () {
                            context.pop();
                            widget.onTap(suggestion);
                          },
                        );
                      },
                    ),
              loading: () => const LoadingSearch(),
              error: (_, __) => const Text('An error occurred!'));
        },
      ),
      suggestionsBuilder: (_, __) => [],
      viewOnChanged: onChange,
    );
  }

  onChange(String val) {
    ref.read(pRecipeSearchTermProvider.notifier).set(val);
  }

  close() {
    _controller.closeView(null);
    _controller.clear();
    ref.read(pRecipeSearchTermProvider.notifier).set('');
  }
}
