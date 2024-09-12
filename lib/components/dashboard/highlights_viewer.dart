import 'package:flavormate/components/dashboard/empty_message.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/highlight.dart';
import 'package:flavormate/riverpod/highlights/p_highlight.dart';
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
        type: TImageType.network,
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
          SizedBox(
            height: 60,
            child: Center(
              child: TText(
                L10n.of(context).c_dashboard_highlights,
                TextStyles.displaySmall,
                color: TextColor.onPrimaryContainer,
              ),
            ),
          ),
          SizedBox(
            height: 400,
            width: double.infinity,
            child: RStruct(
              provider,
              (_, highlights) => highlights.page.empty
                  ? EmptyMessage(
                      title: L10n.of(context).c_dashboard_highlights_no_title,
                      subtitle:
                          L10n.of(context).c_dashboard_highlights_no_subtitle,
                    )
                  : TCarousel(
                      slides: highlights.content
                          .map((h) => getSlide(context, h))
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
