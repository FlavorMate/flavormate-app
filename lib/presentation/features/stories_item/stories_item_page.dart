import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_bubble.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/stories_item/providers/p_stories_item_page.dart';
import 'package:flavormate/presentation/features/stories_item/widgets/stories_item_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoriesItemPage extends ConsumerStatefulWidget {
  final String id;

  const StoriesItemPage({required this.id, super.key});

  PStoriesItemPageProvider get provider =>
      pStoriesItemPageProvider(storyId: id);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoriesItemPageState();
}

class _StoriesItemPageState extends ConsumerState<StoriesItemPage> {
  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, data) => FAppBar(
        title: data.story.label,
        actions: [
          Visibility(
            visible: data.isOwner || data.isAdmin,
            child: StoriesItemActionButton(
              isAdmin: data.isAdmin,
              isOwner: data.isOwner,
              edit: () => edit(),
              delete: () => delete(),
            ),
          ),
        ],
      ),
      builder: (_, data) => FResponsive(
        child: FCard(
          padding: 0,
          child: Column(
            spacing: PADDING,
            children: [
              FImageCard.maximized(
                label: data.story.recipe.label,
                coverSelector: (resolution) =>
                    data.story.cover?.url(resolution),
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
                          account: data.story.ownedBy,
                          border: true,
                        ),
                        Expanded(
                          child: FBubble(
                            topLeft: true,
                            children: [
                              FText(
                                data.story.label,
                                style: FTextStyle.titleLarge,
                                color: FTextColor.filledButton,
                              ),
                              FText(
                                data.story.content,
                                style: FTextStyle.bodyMedium,
                                color: FTextColor.filledButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FilledButton(
                      onPressed: () =>
                          context.routes.recipesItem(data.story.recipe.id),
                      child: Text(
                        L10n.of(context).stories_item_page__open_recipe,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).stories_item_page__on_error,
        icon: StateIconConstants.stories.errorIcon,
      ),
    );
  }

  void edit() async {
    context.showLoadingDialog();

    final response = await ref.read(widget.provider.notifier).editStory();

    if (!mounted) return;
    context.pop();

    if (response.hasError || !response.hasData) {
      context.showTextSnackBar(
        L10n.of(context).stories_item_page__edit_on_error,
      );
    } else {
      await context.routes.storyEditorItem(response.data!);
    }
  }

  void delete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: L10n.of(context).stories_item_page__delete,
      ),
    );
    if (result != true || !mounted) return;

    context.showLoadingDialog();

    final response = await ref.read(widget.provider.notifier).deleteStory();

    if (!mounted) return;

    if (response.hasError) {
      context.showTextSnackBar(
        L10n.of(context).stories_item_page__delete_failure,
      );
    } else {
      ref.invalidate(pRestStoriesProvider);

      context.routes.home(replace: true);
      context.showTextSnackBar(
        L10n.of(context).stories_item_page__delete_success,
      );
    }
  }
}
