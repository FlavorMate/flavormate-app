import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_full_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flavormate/presentation/features/library/dialogs/create_book_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  static final pageKey = PageableState.booksOwnView.name;

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with FOrderMixin<LibraryPage> {
  final _controller = ScrollController();

  PRestBooksProvider get provider => pRestBooksProvider(
    pageProviderId: LibraryPage.pageKey,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final self = ref.watch(pRestAccountsSelfProvider).value;

    return Scaffold(
      appBar: FAppBar(
        controller: _controller,
        title: context.l10n.flavormate,
        showHome: false,
        actions: [
          IconButton(
            onPressed: handleFilterDialog,
            icon: const Icon(MdiIcons.filter),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addBook(context, ref),
        child: const Icon(MdiIcons.plus),
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            FConstrainedBoxSliver(
              maxWidth: FBreakpoint.smValue,
              padding: const .all(PADDING),
              sliver: SliverMainAxisGroup(
                slivers: [
                  FPageIntroductionSliver(
                    shape: .c12_sided_cookie,
                    icon: MdiIcons.bookshelf,
                    description: context.l10n.library_page__description,
                  ),

                  if (self != null) ...[
                    const FSizedBoxSliver(height: PADDING),

                    SliverToBoxAdapter(
                      child: FTileGroup(
                        title: context.l10n.library_page__quick_access,
                        items: [
                          FTile(
                            leading: const FTileIcon(
                              icon: MdiIcons.foodVariant,
                            ),
                            label: context.l10n.library_page__qa_recipes_title,
                            subLabel: context
                                .l10n
                                .library_page__qa_recipes_description,
                            onTap: () =>
                                context.routes.accountsItemRecipes(self.id),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const FSizedBoxSliver(height: PADDING),

                  SliverToBoxAdapter(
                    child: FText(
                      context.l10n.library_page__books,
                      style: .bodyMedium,
                      fontWeight: .w500,
                      color: .primary,
                    ),
                  ),

                  const FSizedBoxSliver(height: 4),

                  FLazySliverList(
                    key: orderKey,
                    provider: provider,
                    pageProvider: widget.pageProvider,
                    scrollController: _controller,

                    itemBuilder: (item, index, first, last) {
                      final stateLabel = item.visible
                          ? context.l10n.library_page__book_public
                          : context.l10n.library_page__book_private;

                      final recipeCountLabel = context.l10n
                          .tags_page__recipe_counter(
                            item.recipeCount,
                          );

                      return FContentFullCard(
                        first: first,
                        last: last,
                        title: item.label,
                        subtitle: '$stateLabel   -   $recipeCountLabel',

                        blurRadius: 2,
                        imageSelector: item.cover?.url,
                        onTap: () => context.routes.libraryItem(item.id),
                      );
                    },
                  ),

                  const FSizedBoxSliver(height: PADDING),

                  const FSizedBoxSliver(height: kFabHeight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addBook(BuildContext context, WidgetRef ref) async {
    final response = await showDialog<String?>(
      context: context,
      builder: (_) => const CreateBookDialog(),
    );

    if (response?.isEmpty ?? true) return;

    await ref.read(provider.notifier).createBook(response!);
  }

  void handleFilterDialog() async {
    final result = await openFilterDialog();
    if (result != null) {
      ref.read(widget.pageProvider.notifier).reset();
    }
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.book;
}
