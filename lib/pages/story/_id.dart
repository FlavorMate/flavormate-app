import 'package:flavormate/components/dialogs/t_confirm_dialog.dart';
import 'package:flavormate/components/dialogs/t_loading_dialog.dart';
import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/story/story_action_button.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_avatar_viewer.dart';
import 'package:flavormate/components/t_bubble.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/stories/p_action_button.dart';
import 'package:flavormate/riverpod/stories/p_stories.dart';
import 'package:flavormate/riverpod/stories/p_story.dart';
import 'package:flavormate/riverpod/story_draft/p_story_drafts.dart';
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
    final userProvider = ref.watch(pActionButtonProvider(int.parse(widget.id)));
    return RScaffold(
      provider,
      appBar: TAppBar(
        title: widget.title ?? L10n.of(context).c_dashboard_stories,
        actions: [
          RStruct(
            userProvider,
            (_, user) => Visibility(
              visible: user.isOwner || user.isAdmin,
              child: StoryActionButton(
                storyId: int.parse(widget.id),
                edit: () => edit(),
                delete: () => delete(),
              ),
            ),
          ),
        ],
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
                    TRow(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AvatarViewer(
                          user: value.author.account,
                          border: true,
                        ),
                        Expanded(
                          child: TBubble(
                            topLeft: true,
                            children: [
                              TText(
                                value.label,
                                TextStyles.titleLarge,
                                color: TextColor.filledButton,
                              ),
                              TText(
                                value.content,
                                TextStyles.bodyMedium,
                                color: TextColor.filledButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FilledButton(
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

  void edit() async {
    showDialog(context: context, builder: (_) => const TLoadingDialog());

    final id =
        await ref.read(pStoryDraftsProvider.notifier).storyToDraft(widget.id);

    if (!mounted) return;
    context.pop();

    if (id == null) {
      context.showTextSnackBar(L10n.of(context).p_story_edit_failed);
    } else {
      context.pushNamed('storyEditor', pathParameters: {'id': '$id'});
    }
  }

  void delete() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => TConfirmDialog(
        title: L10n.of(context).p_story_delete_title,
      ),
    );
    if (!response! || !mounted) return;

    showDialog(context: context, builder: (_) => const TLoadingDialog());

    if (await ref
        .read(pApiProvider)
        .storiesClient
        .deleteById(int.parse(widget.id))) {
      ref.invalidate(pStoriesProvider);

      if (!mounted) return;
      context.pop();
      context.pushReplacementNamed('home');
      context.showTextSnackBar(L10n.of(context).p_story_delete_success);
    } else {
      if (!mounted) return;
      context.pop();
    }
  }
}
