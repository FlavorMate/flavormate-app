import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/stories/p_story.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoryPage extends ConsumerStatefulWidget {
  final String id;
  final String? title;

  const StoryPage({required this.id, required this.title, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StoryPageStore();
}

class _StoryPageStore extends ConsumerState<StoryPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pStoryProvider(int.parse(widget.id)));
    return RScaffold(
      provider,
      appBar: TAppBar(
        title: widget.title ?? L10n.of(context).c_dashboard_stories,
      ),
      builder: (_, value) => TResponsive(
        child: TCard(
          padding: 0,
          child: TColumn(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: TImageLabel(
                  imageSrc: value.recipe.coverUrl,
                  type: TImageType.network,
                  title: value.recipe.label,
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
                    TText(value.label, TextStyles.titleLarge),
                    TText(value.content, TextStyles.bodyMedium),
                    ElevatedButton(
                      onPressed: () => context.pushNamed(
                        'recipe',
                        pathParameters: {'id': '${value.recipe.id}'},
                        extra: value.recipe.label,
                      ),
                      child: Text(L10n.of(context).p_story_go_to_recipe),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
