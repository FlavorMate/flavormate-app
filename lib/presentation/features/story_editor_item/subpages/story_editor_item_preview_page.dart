import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_story/common_story.dart';
import 'package:flavormate/data/repositories/features/story_drafts/p_rest_story_drafts_id.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_story/f_story.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class StoryEditorItemPreviewPage extends ConsumerStatefulWidget {
  final String id;

  const StoryEditorItemPreviewPage({super.key, required this.id});

  PRestStoryDraftsIdProvider get provider =>
      pRestStoryDraftsIdProvider(storyDraftId: id);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoryEditorItemPreviewPageState();
}

class _StoryEditorItemPreviewPageState
    extends ConsumerState<StoryEditorItemPreviewPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, data) => FAppBar(
        scrollController: _scrollController,
        title: data.label!,
      ),
      floatingActionButtonBuilder: (context, _) => M3EFab(
        onPressed: () => uploadStory(context, ref),
        icon: const Icon(Symbols.upload_rounded),
      ),
      builder: (_, data) => FStory(
        controller: _scrollController,
        story: CommonStory.fromDraft(data),
        readOnly: true,
      ),
      onError: FEmptyMessage(
        title: context.l10n.story_editor_item_preview_page__on_error,
        icon: IconConstants.errorIcon,
      ),
    );
  }

  Future<void> uploadStory(BuildContext context, WidgetRef ref) async {
    context.showLoadingDialog();

    final result = await ref.read(widget.provider.notifier).upload();

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
