import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_instruction_groups_item_instruction/providers/p_recipe_editor_item_instruction_groups_item_instruction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemInstructionGroupsItemInstructionPage
    extends ConsumerStatefulWidget {
  const RecipeEditorItemInstructionGroupsItemInstructionPage({
    super.key,
    required this.draftId,
    required this.instructionGroupId,
    required this.instructionId,
  });

  final String draftId;
  final String instructionGroupId;
  final String instructionId;

  PRecipeEditorItemInstructionGroupsItemInstructionProvider get provider =>
      pRecipeEditorItemInstructionGroupsItemInstructionProvider(
        draftId,
        instructionGroupId,
        instructionId,
      );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemInstructionGroupsItemInstructionPageState();
}

class _RecipeEditorItemInstructionGroupsItemInstructionPageState
    extends
        ConsumerState<RecipeEditorItemInstructionGroupsItemInstructionPage> {
  bool _ready = false;

  final _labelController = TextEditingController();
  final _labelDebouncer = Debouncer();

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (_ready) return;

      _labelController.text = data.label ?? '';

      _ready = true;
    });

    super.initState();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _labelDebouncer.dispose();
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
          ).recipe_editor_item_instruction_groups_item_instruction_page__title,
          actions: [
            FProgress(
              provider: widget.provider,
              color: context.colorScheme.onSurface,
              getProgress: (ingredient) => ingredient.validPercent,
            ),
            IconButton(
              onPressed: deleteInstruction,
              icon: const Icon(MdiIcons.delete),
              color: context.blendedColors.error,
            ),
          ],
        ),
        body: SafeArea(
          child: FFixedResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                Expanded(
                  child: FTextFormField(
                    controller: _labelController,
                    suffix: const SizedBox.shrink(),
                    label: L10n.of(
                      context,
                    ).recipe_editor_item_instruction_groups_item_instruction_page__label,
                    onChanged: setLabel,
                    maxLines: null,
                    expands: true,
                  ),
                ),
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

  void deleteInstruction() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: L10n.of(
          context,
        ).recipe_editor_item_instruction_groups_item_instruction_page__delete,
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
