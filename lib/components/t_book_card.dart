import 'package:flavormate/components/dialogs/confirm_dialog.dart';
import 'package:flavormate/components/library/dialogs/edit_book_dialog.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/extensions/e_date_time.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/library/book.dart';
import 'package:flavormate/riverpod/library/p_library.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookCard extends ConsumerWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 450,
      child: TCard(
        padding: 0,
        onTap: () => context.pushNamed(
          'book',
          pathParameters: {'id': book.id.toString()},
          extra: book.label,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TImageLabel(
                  imageSrc: book.recipes!.firstOrNull?.coverUrl,
                  type: TImageType.network,
                  height: 200,
                  title: book.label,
                  labelSize: 0.4,
                ),
                Padding(
                  padding: const EdgeInsets.all(PADDING),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.lastModifiedOn!.toLocalDateString(context),
                      ),
                      Text(
                        book.visible
                            ? L10n.of(context).p_library_public
                            : L10n.of(context).p_library_private,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: PopupMenuButton<String>(
                child: const CircleAvatar(
                  child: Icon(MdiIcons.dotsHorizontal),
                ),
                onSelected: (String item) {
                  if (item == 'edit') {
                    editBook(context, ref, book);
                  } else if (item == 'visibility') {
                    toggleVisibility(context, ref, book);
                  } else if (item == 'delete') {
                    deleteBook(context, ref, book);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(
                      leading: const Icon(MdiIcons.pencil),
                      title: Text(
                        L10n.of(context).p_library_edit,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'visibility',
                    child: ListTile(
                      leading: Icon(
                        book.visible ? MdiIcons.shareOff : MdiIcons.share,
                      ),
                      title: Text(
                        book.visible
                            ? L10n.of(context).p_library_unshare
                            : L10n.of(context).p_library_share,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: const Icon(MdiIcons.trashCan),
                      title: Text(
                        L10n.of(context).p_library_delete,
                      ),
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

  editBook(BuildContext context, WidgetRef ref, Book book) async {
    final response = await showDialog<String>(
      context: context,
      builder: (_) => EditBookDialog(label: book.label),
    );

    if (response?.isEmpty ?? true) return;

    await ref.read(pLibraryProvider.notifier).updateBook(book.id!, response!);
  }

  toggleVisibility(BuildContext context, WidgetRef ref, Book book) async {
    await ref
        .read(pLibraryProvider.notifier)
        .toggleVisibility(book.id!, !book.visible);
  }

  deleteBook(BuildContext context, WidgetRef ref, Book book) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) =>
          ConfirmDialog(title: L10n.of(context).d_library_delete_title),
    );

    if (response ?? false) {
      await ref.read(pLibraryProvider.notifier).deleteBook(book);
    }
  }
}
