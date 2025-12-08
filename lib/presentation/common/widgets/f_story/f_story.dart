import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_story/common_story.dart';
import 'package:flavormate/presentation/common/widgets/f_bubble.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FStory extends StatelessWidget {
  final CommonStory story;
  final bool readOnly;

  const FStory({super.key, required this.story, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return FResponsive(
      child: FCard(
        padding: 0,
        child: Column(
          spacing: PADDING,
          children: [
            FImageCard.maximized(
              label: story.recipe.label,
              coverSelector: (resolution) =>
                  story.recipe.cover?.url(resolution),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: PADDING,
                right: PADDING,
                bottom: PADDING,
              ),
              child: Column(
                spacing: PADDING,
                children: [
                  Row(
                    spacing: PADDING,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FCircularAvatarViewer(
                        account: story.ownedBy,
                        border: true,
                      ),
                      Expanded(
                        child: FBubble(
                          topLeft: true,
                          children: [
                            FText(
                              story.label,
                              style: FTextStyle.titleLarge,
                              color: FTextColor.filledButton,
                            ),
                            FText(
                              story.content,
                              style: FTextStyle.bodyMedium,
                              color: FTextColor.filledButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!readOnly)
                    FilledButton(
                      onPressed: () =>
                          context.routes.recipesItem(story.recipe.id),
                      child: Text(
                        context.l10n.stories_item_page__open_recipe,
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
}
