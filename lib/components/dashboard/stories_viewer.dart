import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/story.dart';
import 'package:flavormate/riverpod/stories/p_stories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoriesViewer extends ConsumerWidget {
  const StoriesViewer({
    super.key,
  });

  TSlide getSlide(BuildContext context, Story story) => TSlide(
        imageSrc: story.recipe.coverUrl,
        title: story.label,
        type: TImageType.network,
        date: story.createdOn,
        onTap: () => context.pushNamed(
          'recipe',
          pathParameters: {'id': '${story.recipe.id}'},
          extra: story.recipe.label,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pStoriesProvider);
    return RStruct(
      provider,
      (_, stories) => Visibility(
        visible: !stories.page.empty,
        child: TCard(
          padding: 4,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: TText(
                  L10n.of(context).c_dashboard_stories,
                  TextStyles.displaySmall,
                  color: TextColor.onPrimaryContainer,
                ),
              ),
              TCarousel(
                height: 400,
                slides:
                    stories.content.map((s) => getSlide(context, s)).toList(),
              ),
            ],
          ),
        ),
      ),
      loadingChild: TCard(
        padding: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TText(
                L10n.of(context).c_dashboard_stories,
                TextStyles.displaySmall,
                color: TextColor.onPrimaryContainer,
              ),
            ),
            const SizedBox(
              height: 400,
              width: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
