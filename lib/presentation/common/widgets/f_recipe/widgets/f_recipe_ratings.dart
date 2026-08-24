import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/extension/ratings/p_rest_ratings_id.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class FRecipeRatings extends StatelessWidget {
  final String recipeId;

  final Function(double?) onRatingTap;

  PRestRatingsIdProvider get provider => pRestRatingsIdProvider(recipeId);

  const FRecipeRatings({
    super.key,
    required this.recipeId,
    required this.onRatingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      children: [
        FText(
          context.l10n.f_recipe_ratings__title,
          style: FTextStyle.headlineMedium,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          width: 450,
          child: Card.outlined(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(PADDING),
              child: FProviderStruct(
                provider: provider,
                builder: (_, data) {
                  return Column(
                    spacing: PADDING / 4,
                    children: [
                      if (data != null) ...[
                        Row(
                          children: [
                            SizedBox(
                              width: 46,
                              child: FText(
                                data.average.toStringAsFixed(1),
                                style: .headlineMedium,
                                fontWeight: .bold,
                                fontRoundness: 100,
                              ),
                            ),
                            const SizedBox(width: PADDING * 2),
                            Expanded(
                              child: Column(
                                children: [
                                  _StarBar(
                                    level: 5,
                                    count: data.star5,
                                    allCount: data.total,
                                  ),
                                  _StarBar(
                                    level: 4,
                                    count: data.star4,
                                    allCount: data.total,
                                  ),
                                  _StarBar(
                                    level: 3,
                                    count: data.star3,
                                    allCount: data.total,
                                  ),
                                  _StarBar(
                                    level: 2,
                                    count: data.star2,
                                    allCount: data.total,
                                  ),
                                  _StarBar(
                                    level: 1,
                                    count: data.star1,
                                    allCount: data.total,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: .centerRight,
                          child: FText(
                            context.l10n.f_recipe_ratings__rating(data.total),
                            style: .bodyMedium,
                          ),
                        ),
                        const Divider(),
                      ],
                      FText(
                        context.l10n.f_recipe_ratings__your_rating,
                        style: .titleMedium,
                      ),
                      SingleChildScrollView(
                        scrollDirection: .horizontal,
                        child: Row(
                          mainAxisAlignment: .center,
                          children: [
                            for (double i = 1; i <= 5; i++)
                              M3EIconButton(
                                icon: Icon(
                                  Symbols.star_rounded,
                                  fill: (data?.ownRating ?? 0) >= i ? 1 : 0,
                                ),
                                onPressed: () => onRatingTap(i),
                              ),
                            if (data?.ownRating != null) ...[
                              const SizedBox(width: PADDING),
                              M3EIconButton(
                                icon: Icon(
                                  Symbols.delete_rounded,
                                  color: context.blendedColors.error,
                                ),
                                onPressed: () => onRatingTap(null),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
                onError: FEmptyMessage(
                  title: context.l10n.f_recipe_ratings__on_error,
                  icon: IconConstants.errorIcon,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StarBar extends StatelessWidget {
  final int level;
  final int count;
  final int allCount;

  const _StarBar({
    required this.level,
    required this.count,
    required this.allCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: PADDING,
      children: [
        SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: .end,
            children: [
              for (int i = 0; i < level; i++)
                const Icon(
                  Symbols.star_rounded,
                  fill: 1,
                  size: 16,
                ),
            ],
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: count / allCount,
            borderRadius: BorderRadius.circular(
              BORDER_RADIUS,
            ),
          ),
        ),
      ],
    );
  }
}
