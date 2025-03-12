import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/story_editor/d_preview.dart';
import 'package:flavormate/components/story_editor/recipe_search.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_text_form_field.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/models/story_draft/story_draft.dart';
import 'package:flavormate/riverpod/story_draft/p_story_draft.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoryEditorPage extends ConsumerStatefulWidget {
  final String id;

  const StoryEditorPage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoryEditorPageState();
}

class _StoryEditorPageState extends ConsumerState<StoryEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _labelController = TextEditingController();

  @override
  void initState() {
    ref.listenManual(pStoryDraftProvider(widget.id), fireImmediately: true, (
      _,
      value,
    ) {
      if (!value.hasValue) return;

      _contentController.text = value.value!.content ?? '';
      _labelController.text = value.value!.label ?? '';
    });
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pStoryDraftProvider(widget.id));
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_story_title),
      body: RStruct(
        provider,
        (_, draft) => TResponsive(
          child: Form(
            key: _formKey,
            child: TColumn(
              children: [
                RecipeSearch(onTap: setRecipe),
                if (draft.recipe != null)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: TImageLabel(
                      imageSrc: draft.recipe!.coverUrl,
                      type: TImageType.network,
                      height: 350,
                      title: draft.recipe!.label,
                    ),
                  ),
                TTextFormField(
                  controller: _labelController,
                  label: L10n.of(context).p_story_label,
                  onChanged:
                      (val) => ref
                          .read(pStoryDraftProvider(widget.id).notifier)
                          .setLabel(EString.trimToNull(val)),
                  validators: (value) {
                    if (UValidator.isEmpty(value)) {
                      return L10n.of(context).v_isEmpty;
                    }

                    return null;
                  },
                ),
                TTextFormField(
                  controller: _contentController,
                  label: L10n.of(context).p_story_content,
                  onChanged:
                      (val) => ref
                          .read(pStoryDraftProvider(widget.id).notifier)
                          .setContent(EString.trimToNull(val)),
                  maxLines: null,
                  validators: (value) {
                    if (UValidator.isEmpty(value)) {
                      return L10n.of(context).v_isEmpty;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: RStruct(
        provider,
        (_, draft) => FloatingActionButton(
          onPressed: () => showPreview(context, draft),
          child: Icon(
            MdiIcons.contentSave,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  showPreview(BuildContext context, StoryDraft draft) async {
    if (draft.recipe == null || !_formKey.currentState!.validate()) {
      context.showTextSnackBar(L10n.of(context).p_story_edit_invalid);
      return;
    }

    final response = await showDialog<bool>(
      context: context,
      builder: (_) => DPreview(storyDraft: draft),
      useSafeArea: false,
    );

    if (response != true) return;

    if (!context.mounted) return;
    context.showLoadingDialog();

    var result = false;

    if (draft.version >= 0) {
      result = await ref.read(pStoryDraftProvider(widget.id).notifier).edit();
    } else {
      result = await ref.read(pStoryDraftProvider(widget.id).notifier).upload();
    }

    if (!context.mounted) return;
    if (result) {
      context.showTextSnackBar(L10n.of(context).p_story_editor_upload_success);
      context.goNamed('home');
    } else {
      context.pop();
      context.showTextSnackBar(L10n.of(context).p_story_editor_upload_failed);
    }
  }

  void setRecipe(Recipe recipe) {
    ref.read(pStoryDraftProvider(widget.id).notifier).setRecipe(recipe);
  }
}
