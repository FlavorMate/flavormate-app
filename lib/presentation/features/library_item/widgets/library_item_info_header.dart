import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class LibraryItemInfoHeader extends StatelessWidget {
  final BookDto book;

  const LibraryItemInfoHeader({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: PADDING / 2,
              children: [
                Icon(
                  book.visible ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline,
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
                  const Icon(MdiIcons.accountGroupOutline),
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
        InkWell(
          onTap: () => context.routes.accountsItem(book.ownedBy.id),
          child: Row(
            spacing: PADDING,
            children: [
              FCircleAvatar(
                account: book.ownedBy,
                radius: 24,
              ),
              FText(
                book.ownedBy.displayName,
                style: FTextStyle.titleLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
