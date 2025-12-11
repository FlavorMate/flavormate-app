import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/data/models/local/common_story/common_story.dart';
import 'package:flavormate/presentation/common/widgets/f_message/f_message_group.dart';
import 'package:flavormate/presentation/common/widgets/f_message/f_message_link.dart';
import 'package:flavormate/presentation/common/widgets/f_message/f_message_text.dart';
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
      child: Column(
        spacing: PADDING,
        children: [
          FText(
            DateTime.now().toLocalDateString(context),
            style: .bodyMedium,
            color: .grey,
            weight: .w400,
          ),
          FMessageGroup(
            account: story.ownedBy,
            messages: [
              if (story.cover != null)
                FMessageLink(
                  linkLabel: story.recipe.label,
                  imageBuilder: (resolution) => story.cover!.url(resolution),
                  onTap: () => context.routes.recipesItem(story.recipe.id),
                ),
              FMessageText(
                content: story.label,
                textStyle: .bodyLarge,
                fontWeight: .w600,
              ),
              FMessageText(
                content: story.content,
                textStyle: .bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
