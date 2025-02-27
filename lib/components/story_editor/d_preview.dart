import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/t_avatar_viewer.dart';
import 'package:flavormate/components/t_bubble.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/models/story_draft/story_draft.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DPreview extends ConsumerWidget {
  final StoryDraft storyDraft;

  const DPreview({super.key, required this.storyDraft});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(pUserProvider).requireValue;

    return TFullDialog(
      title: 'Preview',
      submit: () => context.pop(true),
      child: TCard(
        padding: 0,
        child: TColumn(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: TImageLabel(
                imageSrc: storyDraft.recipe!.coverUrl,
                type: TImageType.network,
                title: storyDraft.recipe!.label,
                height: 325,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: PADDING,
                right: PADDING,
                bottom: PADDING,
              ),
              child: TColumn(
                children: [
                  TRow(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvatarViewer(user: user, border: true),
                      Expanded(
                        child: TBubble(
                          topLeft: true,
                          children: [
                            TText(
                              storyDraft.label!,
                              TextStyles.titleLarge,
                              color: TextColor.filledButton,
                            ),
                            TText(
                              storyDraft.content!,
                              TextStyles.bodyMedium,
                              color: TextColor.filledButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
