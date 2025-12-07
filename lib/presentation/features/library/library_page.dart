import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/features/library/dialogs/create_book_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  String get pageProviderId => PageableState.booksOwnView.name;

  PPageableStateProvider get providerPage =>
      pPageableStateProvider(pageProviderId);

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with FOrderMixin<LibraryPage> {
  PRestBooksProvider get provider => pRestBooksProvider(
    pageProviderId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return FPaginatedPage(
      title: L10n.of(context).flavormate,
      emptyAppBar: true,
      floatingActionBar: FloatingActionButton(
        onPressed: () => addBook(context, ref),
        child: const Icon(MdiIcons.plus),
      ),
      provider: provider,
      pageProvider: widget.providerPage,
      onEmpty: FEmptyMessage(
        icon: MdiIcons.bookOffOutline,
        title: L10n.of(context).library_page__on_empty,
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).library_page__on_error,
        icon: StateIconConstants.books.errorIcon,
      ),
      sortBuilder: () => FPaginatedSort(
        currentOrderBy: orderBy,
        currentDirection: orderDirection,
        setOrderBy: setOrderBy,
        setOrderDirection: setOrderDirection,
        options: OrderByConstants.book,
      ),
      itemBuilder: (item) => FImageCard.maximized(
        label: item.label,
        subLabel: item.visible
            ? L10n.of(context).library_page__book_public
            : L10n.of(context).library_page__book_private,
        coverSelector: (resolution) => item.cover?.url(resolution),
        onTap: () => context.routes.libraryItem(item.id),
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

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
