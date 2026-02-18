import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/search/search_dto.dart';
import 'package:flavormate/data/repositories/features/search/p_search.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_provider_state_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_search_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/features/home/widgets/search/providers/p_search_bar_value.dart';
import 'package:flavormate/presentation/features/search/dialogs/search_page_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();

  static final pageKey = PageableState.search.name;

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);
}

class _SearchPageState extends ConsumerState<SearchPage> {
  PSearchProvider get provider =>
      pSearchProvider(_searchTerm, filter: _searchFilter);

  var _searchFilter = SearchDtoSource.values.toSet();
  String _searchTerm = '';
  bool _ready = false;

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  Key get _listKey => ValueKey(_searchTerm.hashCode + _searchFilter.hashCode);

  @override
  void initState() {
    ref.listenManual(pSearchBarValueProvider, fireImmediately: true, (_, data) {
      if (!_ready) {
        _textController.text = data;
        _searchTerm = data;
        _ready = true;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
        title: context.l10n.search_page__title,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            FConstrainedBoxSliver(
              maxWidth: FBreakpoint.smValue,
              padding: const .all(PADDING),
              sliver: SliverMainAxisGroup(
                slivers: [
                  FPageIntroductionSliver(
                    shape: .c12_sided_cookie,
                    icon: MdiIcons.magnify,
                    description: context.l10n.search_page__description,
                  ),

                  const FSizedBoxSliver(height: PADDING),

                  SliverPersistentHeader(
                    floating: true,
                    delegate: _SliverAppBarDelegate(
                      child: Column(
                        spacing: PADDING / 2,
                        children: [
                          SearchBar(
                            controller: _textController,
                            padding: .all(
                              const .symmetric(horizontal: PADDING),
                            ),
                            leading: const Icon(MdiIcons.magnify),
                            hintText:
                                context.l10n.search_page__text_field_label,
                            onChanged: _onSearchChange,
                            trailing: [
                              IconButton(
                                onPressed: _openFilterDialog,
                                icon: const Icon(MdiIcons.filter),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const FSizedBoxSliver(height: PADDING),

                  if (_searchTerm.isNotBlank)
                    FProviderStateSliver(
                      provider: provider,
                      onEmpty: FEmptyMessage(
                        title: context.l10n.f_search_no_result__title,
                        icon: null,
                      ),
                      onError: FEmptyMessage(
                        title: context.l10n.f_search_error__title,
                        icon: null,
                      ),
                      child: FLazySliverList(
                        key: _listKey,
                        provider: provider,
                        pageProvider: widget.pageProvider,
                        scrollController: _scrollController,
                        itemBuilder: (item, index, first, last) {
                          return FContentSearchCard(
                            first: first,
                            last: last,
                            searchDto: item,
                            onTap: () {
                              switch (item.source) {
                                case .Account:
                                  context.routes.accountsItem(item.id);
                                  return;
                                case .Book:
                                  context.routes.libraryItem(item.id);
                                  return;
                                case .Category:
                                  context.routes.categoriesItem(item.id);
                                  return;
                                case .Recipe:
                                  context.routes.recipesItem(item.id);
                                  return;
                                case .Story:
                                  context.routes.storiesItem(item.id);
                                  return;
                                case .Tag:
                                  context.routes.tagsItem(item.id);
                                  return;
                              }
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterDialog() async {
    final response = await showDialog<Set<SearchDtoSource>>(
      context: context,
      builder: (_) => SearchPageFilterDialog(currentFilters: _searchFilter),
    );

    if (response == null) return;

    setState(() {
      _searchFilter = response;
    });
  }

  void _onSearchChange(String val) {
    setState(() {
      _searchTerm = val;
      ref.read(widget.pageProvider.notifier).reset();
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.child,
  });

  final Widget child;

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: context.colorScheme.surface, child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
