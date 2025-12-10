import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_instruction_group_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress_color.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_rounded_list_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_instruction_groups/providers/p_recipe_editor_item_instruction_groups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemInstructionGroupsPage extends ConsumerStatefulWidget {
  const RecipeEditorItemInstructionGroupsPage({
    super.key,
    required this.draftId,
  });

  final String draftId;

  PRecipeEditorItemInstructionGroupsProvider get provider =>
      pRecipeEditorItemInstructionGroupsProvider(draftId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemInstructionGroupsPageState();
}

class _RecipeEditorItemInstructionGroupsPageState
    extends ConsumerState<RecipeEditorItemInstructionGroupsPage> {
  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, data) => FAppBar(
        title: context.l10n.recipe_editor_item_instruction_groups_page__title,
        actions: [
          FProgressColor(
            state: calcProgress(data),
            color: context.colorScheme.onSurface,
          ),
        ],
      ),
      floatingActionButtonBuilder: (_, _) => FloatingActionButton.extended(
        icon: const Icon(MdiIcons.plus),
        label: Text(
          context.l10n.recipe_editor_item_instruction_groups_page__create_group,
        ),
        onPressed: createGroup,
      ),
      builder: (_, data) => FFixedResponsive(
        child: Column(
          spacing: PADDING,
          children: [
            Expanded(
              child: Card.outlined(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final group = data.elementAt(index);
                    return FRoundedListTile(
                      key: ValueKey(group.id),
                      onTap: () => openGroup(group.id),
                      title: Text(getName(context, group.label, index)),
                      trailing: Row(
                        spacing: PADDING,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FProgressColor(
                            state: group.validPercent,
                            dynamicColors: true,
                          ),
                          ReorderableDragStartListener(
                            index: index,
                            child: const Icon(MdiIcons.reorderHorizontal),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: data.length,
                  onReorder: reorder,
                ),
              ),
            ),

            /// Needed to prevent list behind FAB
            const SizedBox(height: 56),
          ],
        ),
      ),
      onError: FEmptyMessage(
        title:
            context.l10n.recipe_editor_item_instruction_groups_page__on_empty,
        icon: StateIconConstants.drafts.errorIcon,
      ),
    );
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).reorder(oldIndex, newIndex);

    if (!mounted) return;
    context.pop();
  }

  void openGroup(String id) {
    context.routes.recipeEditorItemInstructionGroupsItem(widget.draftId, id);
  }

  void createGroup() async {
    context.showLoadingDialog();
    final id = await ref.read(widget.provider.notifier).createGroup();

    if (!mounted) return;
    context.pop();

    openGroup(id);
  }

  String getName(BuildContext context, String? val, int index) {
    return EString.isEmpty(val)
        ? context.l10n.recipe_editor_item_instruction_groups_page__label(
            index + 1,
          )
        : val!;
  }

  double calcProgress(List<RecipeDraftInstructionGroupDto> groups) {
    if (groups.isEmpty) return 0;
    return groups.where((group) => group.isValid).length / groups.length;
  }
}
