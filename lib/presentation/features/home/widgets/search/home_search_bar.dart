import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_list.dart';
import 'package:flavormate/data/models/shared/models/search_result.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_search/f_search_no_result.dart';
import 'package:flavormate/presentation/common/widgets/f_search/f_search_term_too_short.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/features/home/widgets/search/providers/p_search_bar.dart';
import 'package:flavormate/presentation/features/home/widgets/search/providers/p_search_bar_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeSearchBar extends ConsumerStatefulWidget {
  const HomeSearchBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeSearchBarState();

  PSearchBarProvider get provider => pSearchBarProvider;

  PSearchBarValueProvider get searchTermProvider => pSearchBarValueProvider;
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> {
  late SearchController _controller;
  late String _searchHint;

  @override
  void initState() {
    _controller = SearchController();
    _searchHint = '';
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _searchHint = getMessage(context);
    return SearchAnchor(
      keyboardType: TextInputType.visiblePassword,
      searchController: _controller,
      builder: (_, controller) => SearchBar(
        leading: const IconButton(
          icon: Icon(MdiIcons.magnify),
          onPressed: null,
        ),
        hintText: _searchHint,
        onTap: controller.openView,
      ),
      viewHintText: L10n.of(context).home_search_bar__search_hint,
      viewLeading: IconButton(
        onPressed: close,
        icon: const Icon(MdiIcons.arrowLeft),
      ),
      viewBuilder: (_) => Consumer(
        builder: (_, ref, _) {
          final searchTerm = ref.watch(widget.searchTermProvider);

          if (searchTerm.length < 3) {
            return const FSearchTermTooShort();
          }

          return FProviderStruct(
            provider: widget.provider,
            builder: (context, data) {
              if (data.isEmpty) {
                return const FSearchNoResult();
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) {
                  final suggestion = data[index];
                  return ListTile(
                    title: Text(suggestion.label),
                    leading: Icon(suggestion.icon),
                    onTap: () => openSuggestion(suggestion),
                  );
                },
              );
            },
            onError: FEmptyMessage(
              title: L10n.of(context).home_search_bar__search_on_error,
              icon: StateIconConstants.search.errorIcon,
            ),
          );
        },
      ),
      suggestionsBuilder: (_, _) => [],
      viewOnChanged: onChange,
      viewOnClose: () async {
        await Future.delayed(Duration.zero);
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  void openSuggestion(SearchResult result) {
    switch (result.type) {
      case SearchResultType.author:
        context.routes.accountsItem(result.id);
        return;
      case SearchResultType.book:
        context.routes.libraryItem(result.id);
        return;
      case SearchResultType.category:
        context.routes.categoriesItem(result.id);
        return;
      case SearchResultType.recipe:
        context.routes.recipesItem(result.id);
        return;
      case SearchResultType.story:
        context.routes.storiesItem(result.id);
        return;
      case SearchResultType.tag:
        context.routes.tagsItem(result.id);
        return;
    }
  }

  String getMessage(BuildContext context) => [
    L10n.of(context).home_search_bar__search_authors,
    L10n.of(context).home_search_bar__search_books,
    L10n.of(context).home_search_bar__search_categories,
    L10n.of(context).home_search_bar__search_recipes,
    L10n.of(context).home_search_bar__search_tags,
  ].random()!;

  void onChange(String val) {
    ref.read(widget.searchTermProvider.notifier).set(val);
  }

  void close() {
    _controller.closeView(null);
    _controller.clear();
    ref.read(pSearchBarValueProvider.notifier).set('');
  }
}
