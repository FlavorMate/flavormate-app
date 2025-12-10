import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/timer/p_timer.dart';
import 'package:flavormate/core/riverpod/timer/timer_state.dart';
import 'package:flavormate/core/utils/debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/features/story_drafts/story_draft_dto.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_id.dart';
import 'package:flavormate/data/repositories/features/story_drafts/p_rest_story_drafts_id.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_save_state.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/features/story_editor_item/widgets/story_editor_item_recipe_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryEditorItemPage extends ConsumerStatefulWidget {
  final String id;

  const StoryEditorItemPage({super.key, required this.id});

  PRestStoryDraftsIdProvider get provider =>
      pRestStoryDraftsIdProvider(storyDraftId: id);

  PTimerProvider get autosaveProvider =>
      pTimerProvider(TimerState.storyEditor.getId(id));

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoryEditorPageState();
}

class _StoryEditorPageState extends ConsumerState<StoryEditorItemPage> {
  bool _ready = false;

  final _formKey = GlobalKey<FormState>();

  final _contentController = TextEditingController();
  final _contentDebouncer = Debouncer();
  final _labelController = TextEditingController();
  final _labelDebouncer = Debouncer();

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (_ready) return;
      _contentController.text = data.content ?? '';
      _labelController.text = data.label ?? '';

      _ready = true;
    });

    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentDebouncer.dispose();
    _labelController.dispose();
    _labelDebouncer.dispose();
    super.dispose();
  }

  @override
  void deactivate() async {
    if (ref.read(widget.autosaveProvider) != null) {
      // await ref.read(widget.provider.notifier).save();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, _) => FAppBar(
        title: context.l10n.story_editor_item_page__title,
        actions: [FSaveState(provider: widget.autosaveProvider)],
      ),
      floatingActionButtonBuilder: (_, data) => FloatingActionButton(
        onPressed: () => showPreview(context, data),
        child: Icon(
          MdiIcons.contentSave,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      builder: (_, data) => FResponsive(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: PADDING,
            children: [
              if (data.recipe == null)
                StoryEditorItemRecipeSearch(onTap: setRecipe)
              else
                FProviderStruct(
                  provider: pRestRecipesIdProvider(data.recipe!.id),
                  builder: (_, recipe) => Stack(
                    children: [
                      FImageCard.maximized(
                        label: recipe.label,
                        coverSelector: (resolution) =>
                            recipe.cover?.url(resolution),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () => setRecipe(''),
                          icon: const CircleAvatar(
                            child: Icon(MdiIcons.delete),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onError: FEmptyMessage(
                    title: context.l10n.story_editor_item_page__recipe_on_error,
                    icon: StateIconConstants.recipes.errorIcon,
                  ),
                ),

              FTextFormField(
                controller: _labelController,
                label: context.l10n.story_editor_item_page__label,
                onChanged: setLabel,
                clear: () => setLabel(''),
                validators: (value) {
                  if (UValidator.isEmpty(value)) {
                    return context.l10n.validator__is_empty;
                  }

                  return null;
                },
              ),
              FTextFormField(
                controller: _contentController,
                label: context.l10n.story_editor_item_page__content,
                onChanged: setContent,
                clear: () => setContent(''),
                maxLines: null,
                validators: (value) {
                  if (UValidator.isEmpty(value)) {
                    return context.l10n.validator__is_empty;
                  }

                  return null;
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      onError: FEmptyMessage(
        title: context.l10n.story_editor_item_page__recipe_on_error,
        icon: StateIconConstants.recipes.errorIcon,
      ),
    );
  }

  Future<void> showPreview(BuildContext context, StoryDraftDto draft) async {
    if (draft.recipe == null || !_formKey.currentState!.validate()) {
      context.showTextSnackBar(
        context.l10n.story_editor_item_page__not_complete,
      );
      return;
    }

    await context.routes.storyEditorItemPreview(widget.id);
  }

  void setRecipe(String recipe) {
    ref.read(widget.provider.notifier).setRecipe(recipe);
  }

  void setContent(String content) {
    _contentDebouncer.run(() {
      ref.read(widget.provider.notifier).setContent(content);
    });
  }

  void setLabel(String label) {
    _labelDebouncer.run(() {
      ref.read(widget.provider.notifier).setLabel(label);
    });
  }
}
