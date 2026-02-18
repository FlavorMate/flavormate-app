import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_tags/providers/p_recipe_editor_item_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditorItemTagsPage extends ConsumerStatefulWidget {
  final String draftId;

  const RecipeEditorItemTagsPage({super.key, required this.draftId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemTagsPageState();

  PRecipeEditorItemTagsProvider get provider =>
      pRecipeEditorItemTagsProvider(draftId);
}

class _RecipeEditorItemTagsPageState
    extends ConsumerState<RecipeEditorItemTagsPage> {
  final _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
        title: context.l10n.recipe_editor_item_tags__title,
        actions: [
          FProgress(
            provider: widget.provider,
            color: context.colorScheme.onSurface,
            optional: true,
            getProgress: (tags) => tags.isNotEmpty ? 1 : 0,
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            FConstrainedBoxSliver(
              maxWidth: FBreakpoint.smValue,
              padding: const .all(PADDING),
              sliver: SliverMainAxisGroup(
                slivers: [
                  FPageIntroductionSliver(
                    shape: .c7_sided_cookie,
                    icon: MdiIcons.tagMultiple,
                    description:
                        context.l10n.recipe_editor_item_tags__description,
                  ),

                  const FSizedBoxSliver(height: PADDING),

                  SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      child: FTextFormField(
                        controller: _tagController,
                        label: context.l10n.recipe_editor_item_tags__add_tag,
                        suffix: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: addTag,
                            child: const Icon(MdiIcons.plus),
                          ),
                        ),
                        onFieldSubmitted: (_) => addTag(),
                        validators: (input) =>
                            UValidatorPresets.isNotEmpty(context, input),
                      ),
                    ),
                  ),

                  const FSizedBoxSliver(height: PADDING),

                  SliverToBoxAdapter(
                    child: FProviderStruct(
                      provider: widget.provider,
                      builder: (_, data) => FWrap(
                        children: [
                          for (final tag in data)
                            Chip(
                              label: Text('#$tag'),
                              onDeleted: () => deleteTag(tag),
                            ),
                        ],
                      ),
                      onError: FEmptyMessage(
                        title: context.l10n.recipe_editor_item_tags__on_error,
                        icon: StateIconConstants.tags.errorIcon,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTag() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(widget.provider.notifier)
        .addTag(_tagController.text.toLowerCase());

    _tagController.clear();
  }

  void deleteTag(String draft) {
    ref.read(widget.provider.notifier).deleteTag(draft);
  }
}
