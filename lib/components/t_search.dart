import 'package:flavormate/components/search/loading_search.dart';
import 'package:flavormate/components/search/nothing_found.dart';
import 'package:flavormate/components/search/search_term_too_short.dart';
import 'package:flavormate/extensions/e_list.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/search/p_search.dart';
import 'package:flavormate/riverpod/search/p_search_term.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TSearch extends ConsumerStatefulWidget {
  const TSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TSearchState();
}

class _TSearchState extends ConsumerState<TSearch> {
  final _controller = SearchController();
  String searchHint = '';

  String getMessage(BuildContext context) =>
      [
        L10n.of(context).c_search_label_author,
        L10n.of(context).c_search_label_book,
        L10n.of(context).c_search_label_category,
        L10n.of(context).c_search_label_recipe,
        L10n.of(context).c_search_label_tag,
      ].random()!;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchHint = getMessage(context);
    return SearchAnchor(
      keyboardType: TextInputType.visiblePassword,
      searchController: _controller,
      builder:
          (_, controller) => SearchBar(
            leading: const IconButton(
              icon: Icon(MdiIcons.magnify),
              onPressed: null,
            ),
            hintText: searchHint,
            onTap: controller.openView,
          ),
      viewHintText: L10n.of(context).c_search_hint,
      viewLeading: IconButton(
        onPressed: close,
        icon: const Icon(MdiIcons.arrowLeft),
      ),
      viewBuilder:
          (_) => Consumer(
            builder: (_, ref, __) {
              final searchTerm = ref.read(pSearchTermProvider);
              return ref
                  .watch(pSearchProvider)
                  .when(
                    data:
                        (suggestions) =>
                            suggestions.isEmpty
                                ? searchTerm.length < 3
                                    ? const SearchTermTooShort()
                                    : const NothingFound()
                                : ListView.builder(
                                  itemCount: suggestions.length,
                                  itemBuilder: (_, index) {
                                    final suggestion = suggestions[index];
                                    return ListTile(
                                      title: Text(suggestion.label),
                                      leading: Icon(suggestion.icon),
                                      onTap:
                                          () => context.pushNamed(
                                            suggestion.type.name,
                                            pathParameters: {
                                              'id': '${suggestion.id}',
                                            },
                                            extra: suggestion.label,
                                          ),
                                    );
                                  },
                                ),
                    loading: () => const LoadingSearch(),
                    error: (_, __) => const Text('An error occurred!'),
                  );
            },
          ),
      suggestionsBuilder: (_, __) => [],
      viewOnChanged: onChange,
    );
  }

  onChange(String val) {
    ref.read(pSearchTermProvider.notifier).set(val);
  }

  close() {
    _controller.closeView(null);
    _controller.clear();
    ref.read(pSearchTermProvider.notifier).set('');
  }
}
