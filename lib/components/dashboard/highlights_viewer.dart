import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/highlight.dart';
import 'package:flavormate/riverpod/highlights/p_highlight.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HighlightsViewer extends ConsumerWidget {
  const HighlightsViewer({
    super.key,
  });

  TSlide getSlide(BuildContext context, Highlight highlight) => TSlide(
        imageSrc: highlight.recipe.coverUrl,
        title: highlight.recipe.label,
        date: highlight.date,
        onTap: () => context.pushNamed(
          'recipe',
          pathParameters: {'id': '${highlight.recipe.id}'},
          extra: highlight.recipe.label,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pHighlightProvider);
    return TCard(
      padding: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(PADDING / 2),
            child: TText(
              L10n.of(context).c_dashboard_highlights,
              TextStyles.displaySmall,
              color: TextColor.onPrimaryContainer,
            ),
          ),
          RStruct(
            provider,
            (_, highlights) => TCarousel(
              height: 400,
              slides:
                  highlights.content.map((h) => getSlide(context, h)).toList(),
            ),
            loadingChild: const SizedBox(
              height: 400,
              width: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
