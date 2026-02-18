import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_list.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_search_history.dart';
import 'package:flavormate/data/models/features/search/search_dto.dart';
import 'package:flavormate/data/repositories/features/search/p_search.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/features/home/widgets/search/providers/p_search_bar_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeSearchBar extends ConsumerStatefulWidget {
  final double elevation;

  const HomeSearchBar({super.key, this.elevation = 6.0});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeSearchBarState();

  PSearchBarValueProvider get searchTermProvider => pSearchBarValueProvider;
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> {
  final SearchController _controller = SearchController();

  PSearchProvider get provider =>
      pSearchProvider(_controller.text, filter: SearchDtoSource.values.toSet());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchHint = _randomSearchHint(context);

    return SearchAnchor(
      keyboardType: TextInputType.visiblePassword,
      searchController: _controller,
      builder: (_, controller) => SearchBar(
        elevation: .all(widget.elevation),
        readOnly: true,
        leading: const Icon(MdiIcons.magnify),
        padding: .all(const .symmetric(horizontal: PADDING)),
        hintText: searchHint,
        onTap: controller.openView,
      ),
      viewOnSubmitted: _openSuggestion,
      viewHintText: context.l10n.home_search_bar__search_hint,
      viewLeading: IconButton(
        onPressed: _close,
        icon: const Icon(MdiIcons.arrowLeft),
      ),
      viewBuilder: (_) => Consumer(
        builder: (_, ref, _) {
          final searchTerm = ref.watch(widget.searchTermProvider);
          final searchHistory = ref.watch(pSPSearchHistoryProvider);

          if (searchTerm.isBlank) {
            return _buildRecentSearches(context, ref, searchHistory);
          }

          return FProviderStruct(
            provider: provider,
            builder: (context, data) => ListView.builder(
              itemCount: data.data.length,
              itemBuilder: (_, index) {
                final suggestion = data.data[index];
                return ListTile(
                  leading: const Icon(MdiIcons.magnify),
                  title: Text(suggestion.label),
                  onTap: () => _openSuggestion(suggestion.label),
                );
              },
            ),
            onError: FEmptyMessage(
              title: context.l10n.home_search_bar__search_on_error,
              icon: StateIconConstants.search.errorIcon,
            ),
          );
        },
      ),
      suggestionsBuilder: (_, _) => [],
      viewOnChanged: _onChange,
      viewOnClose: () async {
        await Future.delayed(Duration.zero);
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  ListView _buildRecentSearches(
    BuildContext context,
    WidgetRef ref,
    List<String> searchHistory,
  ) {
    return ListView.builder(
      itemCount: searchHistory.length,
      itemBuilder: (_, index) {
        final historyItem = searchHistory[searchHistory.length - index - 1];

        return ListTile(
          title: Text(historyItem),
          trailing: IconButton(
            onPressed: () {
              ref.read(pSPSearchHistoryProvider.notifier).remove(historyItem);
            },
            icon: Icon(
              MdiIcons.delete,
              color: context.blendedColors.error,
            ),
          ),
          onTap: () {
            _openSuggestion(historyItem);
          },
        );
      },
    );
  }

  void _openSuggestion(String value) {
    _controller.clear();
    ref.read(pSPSearchHistoryProvider.notifier).add(value);
    ref.read(pSearchBarValueProvider.notifier).set(value);
    context.pop();
    context.routes.search();
    return;
  }

  String _randomSearchHint(BuildContext context) => [
    context.l10n.home_search_bar__search_authors,
    context.l10n.home_search_bar__search_books,
    context.l10n.home_search_bar__search_categories,
    context.l10n.home_search_bar__search_recipes,
    context.l10n.home_search_bar__search_tags,
  ].random()!;

  void _onChange(String val) {
    ref.read(widget.searchTermProvider.notifier).set(val);
  }

  void _close() {
    _controller.closeView(null);
    _controller.clear();
    ref.read(pSearchBarValueProvider.notifier).set('');
  }
}
