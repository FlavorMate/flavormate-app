import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
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
                      ? L10n.of(context).library_item_info_header__public
                      : L10n.of(context).library_item_info_header__private,
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
                    L10n.of(context).library_item_info_header__subscribers(
                      book.subscriberCount,
                    ),
                    style: FTextStyle.bodyMedium,
                  ),
                ],
              ),
          ],
        ),
        Row(
          spacing: PADDING,
          children: [
            FCircularAvatarViewer(
              account: book.ownedBy,
              height: 48,
              width: 48,
            ),
            FText(book.ownedBy.displayName, style: FTextStyle.titleLarge),
          ],
        ),
      ],
    );
  }
}
