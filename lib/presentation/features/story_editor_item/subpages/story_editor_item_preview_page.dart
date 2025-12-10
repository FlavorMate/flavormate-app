import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_story/common_story.dart';
import 'package:flavormate/data/repositories/features/story_drafts/p_rest_story_drafts_id.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_story/f_story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoryEditorItemPreviewPage extends ConsumerWidget {
  final String id;

  const StoryEditorItemPreviewPage({super.key, required this.id});

  PRestStoryDraftsIdProvider get provider =>
      pRestStoryDraftsIdProvider(storyDraftId: id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FProviderPage(
      provider: provider,
      appBarBuilder: (_, data) => FAppBar(title: data.label!),
      floatingActionButtonBuilder: (context, _) => FloatingActionButton(
        onPressed: () => uploadStory(context, ref),
        child: const Icon(MdiIcons.upload),
      ),
      builder: (_, data) => FStory(
        story: CommonStory.fromDraft(data),
        readOnly: true,
      ),
      onError: FEmptyMessage(
        title: context.l10n.story_editor_item_preview_page__on_error,
        icon: StateIconConstants.drafts.errorIcon,
      ),
    );
  }

  Future<void> uploadStory(BuildContext context, WidgetRef ref) async {
    context.showLoadingDialog();

    final result = await ref.read(provider.notifier).upload();

    if (!context.mounted) return;

    context.pop();

    if (!result.hasError) {
      context.routes.home(replace: true);
      context.showTextSnackBar(
        context.l10n.story_editor_item_preview_page__upload_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.story_editor_item_preview_page__upload_failure,
      );
    }
  }
}
