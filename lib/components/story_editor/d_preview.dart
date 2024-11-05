import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/models/story_draft/story_draft.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DPreview extends StatelessWidget {
  final StoryDraft storyDraft;

  const DPreview({super.key, required this.storyDraft});

  @override
  Widget build(BuildContext context) {
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
                  TText(storyDraft.label!, TextStyles.titleLarge),
                  TText(storyDraft.content!, TextStyles.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
