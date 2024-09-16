import 'package:flavormate/components/library/dialogs/create_book_dialog.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_book_card.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/library/p_library.dart';
import 'package:flavormate/riverpod/library/p_library_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pLibraryProvider);

    return RStruct(
      provider,
      (_, library) => Stack(
        children: [
          library.page.empty
              ? Center(
                  child: TEmptyMessage(
                    icon: MdiIcons.bookOffOutline,
                    title: L10n.of(context).p_library_no_book,
                    subtitle: L10n.of(context).p_library_no_book_subtitle,
                  ),
                )
              : TPageable(
                  provider: pLibraryProvider,
                  pageProvider: pLibraryPageProvider,
                  onPressed: (ref, index) =>
                      ref.read(pLibraryPageProvider.notifier).setState(index),
                  builder: (_, library) => TWrap(
                    children: library.content
                        .map((book) => BookCard(book: book))
                        .toList(),
                  ),
                ),
          Positioned(
            right: 16,
            bottom: 48,
            child: Consumer(
              builder: (context, ref, __) => FloatingActionButton(
                onPressed: () => addBook(context, ref),
                child: const Icon(MdiIcons.plus),
              ),
            ),
          ),
        ],
      ),
    );
  }

  addBook(BuildContext context, WidgetRef ref) async {
    final response = await showDialog<String?>(
      context: context,
      builder: (_) => const CreateBookDialog(),
    );
    if (response?.isEmpty ?? true) return;

    await ref.read(pLibraryProvider.notifier).createBook(response!);
  }
}
