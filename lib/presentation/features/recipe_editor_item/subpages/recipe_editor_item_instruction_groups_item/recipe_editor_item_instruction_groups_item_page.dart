import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_instruction_group_dto.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress_color.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_rounded_list_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_instruction_groups_item/providers/p_recipe_editor_item_instruction_groups_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemInstructionGroupsItemPage extends ConsumerStatefulWidget {
  const RecipeEditorItemInstructionGroupsItemPage({
    super.key,
    required this.draftId,
    required this.instructionGroupId,
  });

  final String draftId;
  final String instructionGroupId;

  PRecipeEditorItemInstructionGroupsItemProvider get provider =>
      pRecipeEditorItemInstructionGroupsItemProvider(
        draftId,
        instructionGroupId,
      );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemInstructionGroupsItemPageState();
}

class _RecipeEditorItemInstructionGroupsItemPageState
    extends ConsumerState<RecipeEditorItemInstructionGroupsItemPage> {
  bool _ready = false;

  final _labelController = TextEditingController();
  final _labelDebouncer = Debouncer();
  final _listDebouncer = Debouncer();

  List<RecipeDraftInstructionGroupItemDto> _instructions = [];

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (!_ready) {
        _labelController.text = data.label ?? '';

        _ready = true;
      }

      _instructions = data.instructions.toList().sorted(
        (a, b) => a.index.compareTo(b.index),
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _labelDebouncer.dispose();
    _listDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(widget.provider);
    if (!_ready) {
      return const FLoadingPage();
    } else {
      return Scaffold(
        appBar: FAppBar(
          title: L10n.of(
            context,
          ).recipe_editor_item_instruction_groups_item_page__title,
          actions: [
            FProgress(
              provider: widget.provider,
              color: context.colorScheme.onSurface,
              getProgress: (group) => group.validPercent,
            ),
            IconButton(
              onPressed: deleteIngredientGroup,
              icon: const Icon(MdiIcons.delete),
              color: context.blendedColors.error,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(MdiIcons.plus),
          label: Text(
            L10n.of(
              context,
            ).recipe_editor_item_instruction_groups_item_page__add_instruction,
          ),
          onPressed: createGroup,
        ),
        body: SafeArea(
          child: FFixedResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                FTextFormField(
                  controller: _labelController,
                  label: L10n.of(
                    context,
                  ).recipe_editor_item_instruction_groups_item_page__title,
                  onChanged: setLabel,
                  clear: () => setLabel(''),
                ),

                Expanded(
                  child: Card.outlined(
                    margin: EdgeInsets.zero,
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemBuilder: (context, index) {
                        final ingredient = _instructions.elementAt(index);
                        return FRoundedListTile(
                          key: ValueKey(ingredient.id),
                          onTap: () => openInstruction(ingredient),
                          title: Text(ingredient.label?.shorten() ?? '-'),
                          trailing: Row(
                            spacing: PADDING,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FProgressColor(
                                state: ingredient.validPercent,
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
                      itemCount: _instructions.length,
                      onReorder: reorderItems,
                    ),
                  ),
                ),

                /// Needed to prevent list behind FAB
                const SizedBox(height: 56),
              ],
            ),
          ),
        ),
      );
    }
  }

  void setLabel(String input) {
    _labelDebouncer.run(() {
      ref.read(widget.provider.notifier).setLabel(input);
    });
  }

  void reorderItems(int oldIndex, int newIndex) async {
    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).reorder(oldIndex, newIndex);

    if (!mounted) return;
    context.pop();
  }

  void openInstruction(RecipeDraftInstructionGroupItemDto instruction) {
    context.routes.recipeEditorItemInstructionGroupsItemInstruction(
      widget.draftId,
      widget.instructionGroupId,
      instruction.id,
    );
  }

  void createGroup() async {
    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).createInstruction();

    if (!mounted) return;
    context.pop();
  }

  void deleteIngredientGroup() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: L10n.of(
          context,
        ).recipe_editor_item_instruction_groups_item_page__delete,
      ),
    );

    if (response != true || !mounted) return;
    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).delete();

    if (!mounted) return;
    context.pop();
    context.pop();
  }
}
