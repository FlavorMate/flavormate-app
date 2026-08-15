import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/core/riverpod/search_state/p_search_state.dart';
import 'package:flavormate/core/riverpod/search_state/search_state.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_search.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_search/f_search_no_result.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class StoryEditorItemRecipeSearch extends ConsumerStatefulWidget {
  final Function(String) onTap;

  const StoryEditorItemRecipeSearch({super.key, required this.onTap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipeSearchState();

  PSearchStateProvider get searchTermProvider =>
      pSearchStateProvider(SearchState.storyEditor.name);

  PRestRecipesSearchProvider get provider => pRestRecipesSearchProvider(
    pageProviderId: PageableState.unused.name,
    queryProviderId: SearchState.storyEditor.name,
  );
}

class _RecipeSearchState extends ConsumerState<StoryEditorItemRecipeSearch> {
  final _controller = M3ESearchController();

  @override
  void dispose() {
    /// Add a delay because an exception will be thrown when disposing instantly
    Future.delayed(const Duration(seconds: 1)).then((_) {
      _controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3ESearchAnchor(
      keyboardType: TextInputType.visiblePassword,
      searchController: _controller,
      builder: (_, controller) => FIconButton(
        onPressed: controller.openView,
        label: context.l10n.story_editor_item_recipe_search__search_recipes,
        icon: Symbols.search_rounded,
      ),
      viewHintText: context.l10n.story_editor_item_recipe_search__search_hint,
      viewLeading: M3EIconButton(
        onPressed: close,
        icon: const Icon(Symbols.arrow_back_rounded),
      ),
      viewTrailing: [
        M3EIconButton(
          onPressed: _reset,
          icon: const Icon(Symbols.close_rounded),
        ),
      ],
      viewBuilder: (_) => Consumer(
        builder: (_, ref, _) {
          final searchTerm = ref.watch(widget.searchTermProvider);

          if (searchTerm.isEmpty) {
            return const SizedBox.shrink();
          }

          return FProviderStruct(
            provider: widget.provider,
            builder: (context, data) {
              if (data.data.isEmpty) {
                return const FSearchNoResult();
              }

              return ListView.builder(
                itemCount: data.data.length,
                itemBuilder: (_, index) {
                  final suggestion = data.data[index];
                  return ListTile(
                    title: Text(suggestion.label),
                    leading: const Icon(Symbols.book_rounded),
                    onTap: () {
                      widget.onTap(suggestion.id);
                    },
                  );
                },
              );
            },
            onError: FEmptyMessage(
              title: context.l10n.story_editor_item_recipe_search__on_error,
              icon: IconConstants.errorIcon,
            ),
          );
        },
      ),
      suggestionsBuilder: (_, _) => [],
      viewOnChanged: onChange,
    );
  }

  void onChange(String val) {
    ref.read(widget.searchTermProvider.notifier).set(val);
  }

  void close() {
    _controller.closeView(null);
    _controller.clear();
    ref.read(widget.searchTermProvider.notifier).set(null);
  }

  void _reset() {
    _controller.clear();
    ref.read(widget.searchTermProvider.notifier).set('');
  }
}
