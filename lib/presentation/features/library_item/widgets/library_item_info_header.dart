import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class LibraryItemInfoHeader extends StatelessWidget {
  final BookDto book;

  const LibraryItemInfoHeader({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: PADDING,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: PADDING / 2,
              children: [
                Icon(
                  book.visible
                      ? Symbols.visibility_rounded
                      : Symbols.visibility_off_rounded,
                ),
                FText(
                  book.visible
                      ? context.l10n.library_item_info_header__public
                      : context.l10n.library_item_info_header__private,
                  style: FTextStyle.bodyMedium,
                ),
              ],
            ),
            if (book.visible)
              Row(
                spacing: PADDING / 2,
                children: [
                  const Icon(Symbols.group_rounded),
                  FText(
                    context.l10n.library_item_info_header__subscribers(
                      book.subscriberCount,
                    ),
                    style: FTextStyle.bodyMedium,
                  ),
                ],
              ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: .centerRight,
            child: M3EButton(
              style: .text,
              onPressed: () => context.routes.accountsItem(book.ownedBy.id),
              decoration: .styleFrom(
                padding: const .symmetric(horizontal: 8, vertical: 8),
              ),
              child: Row(
                mainAxisSize: .min,
                spacing: PADDING / 2,
                children: [
                  FCircleAvatar(
                    account: book.ownedBy,
                    radius: 24,
                  ),
                  Flexible(
                    child: FText(
                      book.ownedBy.displayName,
                      style: FTextStyle.titleLarge,
                      textOverflow: .ellipsis,
                      color: .onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
